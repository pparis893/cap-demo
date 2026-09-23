using { FleetService } from './cat-service';

// ---------------------------------------------------------------------------
// Configuración de Semántica de Moneda y Atributos Comunes
// ---------------------------------------------------------------------------
annotate FleetService.Equipments with {
  dailyRate @Measures.ISOCurrency: currency_code;
  currency  @Common.IsCurrency;

  category @(
    Common.Text: category.name,
    Common.TextArrangement: #TextOnly,
    Common.ValueList: {
      Label: 'Categorías de Equipo',
      CollectionPath: 'Categories',
      Parameters: [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: category_code, ValueListProperty: 'code' },
        { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name' },
        { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'description' }
      ]
    }
  );

  status @(
    Common.Text: status.name,
    Common.TextArrangement: #TextOnly,
    Common.ValueList: {
      Label: 'Estados Operativos',
      CollectionPath: 'Statuses',
      Parameters: [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: status_code, ValueListProperty: 'code' },
        { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name' }
      ]
    }
  );
};

annotate FleetService.MaintenanceLogs with {
  cost     @Measures.ISOCurrency: currency_code;
  currency @Common.IsCurrency;
};

// ---------------------------------------------------------------------------
// Entidad Principal: Equipments (List Report y Object Page)
// ---------------------------------------------------------------------------
annotate FleetService.Equipments with @(

  // Identificación y Cabecera de la Entidad
  UI.HeaderInfo: {
    TypeName: 'Equipo Komatsu',
    TypeNamePlural: 'Flota de Equipos Komatsu',
    Title: {
      $Type: 'UI.DataField',
      Value: name
    },
    Description: {
      $Type: 'UI.DataField',
      Value: model
    },
    ImageUrl: imageUrl
  },

  // Filtros Rápidos de la Barra de Búsqueda (Filter Bar en List Report)
  UI.SelectionFields: [
    category_code,
    status_code,
    location
  ],

  // Columnas de la Tabla Principal (List Report Table)
  UI.LineItem: [
    {
      $Type: 'UI.DataField',
      Value: code,
      Label: 'Código'
    },
    {
      $Type: 'UI.DataField',
      Value: name,
      Label: 'Nombre de Equipo'
    },
    {
      $Type: 'UI.DataField',
      Value: category_code,
      Label: 'Categoría'
    },
    {
      $Type: 'UI.DataField',
      Value: status_code,
      Label: 'Estado Operativo',
      Criticality: status.criticality,
      CriticalityRepresentation: #WithoutIcon
    },
    {
      $Type: 'UI.DataField',
      Value: healthScore,
      Label: 'Salud (%)',
      Criticality: status.criticality
    },
    {
      $Type: 'UI.DataField',
      Value: operatingHours,
      Label: 'Horas Operación'
    },
    {
      $Type: 'UI.DataField',
      Value: dailyRate,
      Label: 'Tarifa Diaria'
    },
    {
      $Type: 'UI.DataField',
      Value: location,
      Label: 'Ubicación / Faena'
    }
  ],

  // Indicadores Clave en la Cabecera de la Página de Objeto (Header Facets)
  UI.HeaderFacets: [
    {
      $Type: 'UI.ReferenceFacet',
      Target: '@UI.DataPoint#StatusHeader'
    },
    {
      $Type: 'UI.ReferenceFacet',
      Target: '@UI.DataPoint#OperatingHoursHeader'
    },
    {
      $Type: 'UI.ReferenceFacet',
      Target: '@UI.DataPoint#HealthScoreHeader'
    },
    {
      $Type: 'UI.ReferenceFacet',
      Target: '@UI.DataPoint#DailyRateHeader'
    },
    {
      $Type: 'UI.ReferenceFacet',
      Target: '@UI.FieldGroup#SupervisorHeader'
    }
  ],

  UI.DataPoint #StatusHeader: {
    Value: status_code,
    Title: 'Estado Actual',
    Criticality: status.criticality
  },

  UI.DataPoint #OperatingHoursHeader: {
    Value: operatingHours,
    Title: 'Horas Acumuladas'
  },

  UI.DataPoint #HealthScoreHeader: {
    Value: healthScore,
    Title: 'Índice de Salud',
    Criticality: status.criticality
  },

  UI.DataPoint #DailyRateHeader: {
    Value: dailyRate,
    Title: 'Tarifa / Día'
  },

  UI.FieldGroup #SupervisorHeader: {
    Data: [
      { Value: supervisorName, Label: 'Supervisor Responsable' },
      { Value: supervisorEmail, Label: 'Email' },
      { Value: supervisorPhone, Label: 'Teléfono' }
    ]
  },

  // Secciones del Cuerpo de la Página de Objeto (Object Page Facets)
  UI.Facets: [
    {
      $Type: 'UI.CollectionFacet',
      ID: 'GeneralSection',
      Label: 'Información del Equipo',
      Facets: [
        {
          $Type: 'UI.ReferenceFacet',
          Label: 'Ficha Técnica',
          Target: '@UI.FieldGroup#TechnicalData'
        },
        {
          $Type: 'UI.ReferenceFacet',
          Label: 'Operación y Faena',
          Target: '@UI.FieldGroup#OperationData'
        }
      ]
    },
    {
      $Type: 'UI.ReferenceFacet',
      ID: 'MaintenanceSection',
      Label: 'Historial y Órdenes de Mantenimiento',
      Target: 'maintenanceLogs/@UI.LineItem'
    },
    {
      $Type: 'UI.ReferenceFacet',
      ID: 'AuditSection',
      Label: 'Auditoría del Sistema',
      Target: '@UI.FieldGroup#AuditData'
    }
  ],

  // Grupos de Campos (FieldGroups) para el Object Page
  UI.FieldGroup #TechnicalData: {
    Data: [
      { Value: code, Label: 'Código Identificador' },
      { Value: name, Label: 'Nombre del Equipo' },
      { Value: model, Label: 'Modelo Fabricante' },
      { Value: serialNumber, Label: 'Número de Serie' },
      { Value: category_code, Label: 'Categoría' },
      { Value: manufactureYear, Label: 'Año de Fabricación' },
      { Value: imageUrl, Label: 'URL Imagen' }
    ]
  },

  UI.FieldGroup #OperationData: {
    Data: [
      { Value: status_code, Label: 'Estado Operativo' },
      { Value: location, Label: 'Faena Minera / Ubicación' },
      { Value: operatingHours, Label: 'Horas de Operación' },
      { Value: healthScore, Label: 'Índice de Salud (%)' },
      { Value: dailyRate, Label: 'Tarifa Diaria' },
      { Value: currency_code, Label: 'Moneda' },
      { Value: lastServiceDate, Label: 'Último Servicio Realizado' },
      { Value: nextServiceDate, Label: 'Próximo Servicio Programado' }
    ]
  },

  UI.FieldGroup #AuditData: {
    Data: [
      { Value: createdAt, Label: 'Fecha Creación' },
      { Value: createdBy, Label: 'Creado Por' },
      { Value: modifiedAt, Label: 'Última Modificación' },
      { Value: modifiedBy, Label: 'Modificado Por' }
    ]
  }

);

// ---------------------------------------------------------------------------
// Entidad Detalle: MaintenanceLogs (Tabla hija en Object Page)
// ---------------------------------------------------------------------------
annotate FleetService.MaintenanceLogs with @(

  UI.HeaderInfo: {
    TypeName: 'Orden de Mantenimiento',
    TypeNamePlural: 'Órdenes de Mantenimiento',
    Title: { Value: logNumber }
  },

  UI.LineItem: [
    {
      $Type: 'UI.DataField',
      Value: logNumber,
      Label: 'N° Orden'
    },
    {
      $Type: 'UI.DataField',
      Value: serviceDate,
      Label: 'Fecha Servicio'
    },
    {
      $Type: 'UI.DataField',
      Value: maintenanceType,
      Label: 'Tipo Mantenimiento'
    },
    {
      $Type: 'UI.DataField',
      Value: technician,
      Label: 'Técnico Responsable'
    },
    {
      $Type: 'UI.DataField',
      Value: hoursSpent,
      Label: 'Horas Invertidas'
    },
    {
      $Type: 'UI.DataField',
      Value: cost,
      Label: 'Costo'
    },
    {
      $Type: 'UI.DataField',
      Value: status,
      Label: 'Estado',
      Criticality: criticality
    },
    {
      $Type: 'UI.DataField',
      Value: remarks,
      Label: 'Observaciones Técnicas'
    }
  ],

  UI.Facets: [
    {
      $Type: 'UI.ReferenceFacet',
      Label: 'Detalle de la Orden',
      Target: '@UI.FieldGroup#LogDetail'
    }
  ],

  UI.FieldGroup #LogDetail: {
    Data: [
      { Value: logNumber, Label: 'N° Orden' },
      { Value: serviceDate, Label: 'Fecha de Ejecución' },
      { Value: maintenanceType, Label: 'Tipo de Mantenimiento' },
      { Value: technician, Label: 'Técnico Especialista' },
      { Value: hoursSpent, Label: 'Horas Trabajadas' },
      { Value: cost, Label: 'Costo del Servicio' },
      { Value: currency_code, Label: 'Moneda' },
      { Value: status, Label: 'Estado de la Orden' },
      { Value: remarks, Label: 'Detalles y Observaciones' }
    ]
  }

);
