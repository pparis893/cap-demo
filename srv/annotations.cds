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
      Label: '{i18n>EquipmentCategories}',
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
      Label: '{i18n>OperatingStatuses}',
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
    TypeName: '{i18n>KomatsuEquipment}',
    TypeNamePlural: '{i18n>KomatsuEquipmentFleet}',
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
      Label: '{i18n>Code}'
    },
    {
      $Type: 'UI.DataField',
      Value: name,
      Label: '{i18n>EquipmentName}'
    },
    {
      $Type: 'UI.DataField',
      Value: category_code,
      Label: '{i18n>Category}'
    },
    {
      $Type: 'UI.DataField',
      Value: status_code,
      Label: '{i18n>OperatingStatus}',
      Criticality: status.criticality,
      CriticalityRepresentation: #WithoutIcon
    },
    {
      $Type: 'UI.DataField',
      Value: healthScore,
      Label: '{i18n>Health}',
      Criticality: status.criticality
    },
    {
      $Type: 'UI.DataField',
      Value: operatingHours,
      Label: '{i18n>OperatingHrs}'
    },
    {
      $Type: 'UI.DataField',
      Value: dailyRate,
      Label: '{i18n>DailyRate}'
    },
    {
      $Type: 'UI.DataField',
      Value: location,
      Label: '{i18n>LocationSite}'
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
    Title: '{i18n>CurrentStatus}',
    Criticality: status.criticality
  },

  UI.DataPoint #OperatingHoursHeader: {
    Value: operatingHours,
    Title: '{i18n>AccumulatedHours}'
  },

  UI.DataPoint #HealthScoreHeader: {
    Value: healthScore,
    Title: '{i18n>HealthIndex2}',
    Criticality: status.criticality
  },

  UI.DataPoint #DailyRateHeader: {
    Value: dailyRate,
    Title: '{i18n>RateDay}'
  },

  UI.FieldGroup #SupervisorHeader: {
    Data: [
      { Value: supervisorName, Label: '{i18n>ResponsibleSupervisor}' },
      { Value: supervisorEmail, Label: '{i18n>Email}' },
      { Value: supervisorPhone, Label: '{i18n>Phone}' }
    ]
  },

  // Secciones del Cuerpo de la Página de Objeto (Object Page Facets)
  UI.Facets: [
    {
      $Type: 'UI.CollectionFacet',
      ID: 'GeneralSection',
      Label: '{i18n>EquipmentInformation}',
      Facets: [
        {
          $Type: 'UI.ReferenceFacet',
          Label: '{i18n>TechnicalData}',
          Target: '@UI.FieldGroup#TechnicalData'
        },
        {
          $Type: 'UI.ReferenceFacet',
          Label: '{i18n>OperationAndSite}',
          Target: '@UI.FieldGroup#OperationData'
        }
      ]
    },
    {
      $Type: 'UI.ReferenceFacet',
      ID: 'MaintenanceSection',
      Label: '{i18n>MaintenanceHistoryAndOrders}',
      Target: 'maintenanceLogs/@UI.LineItem'
    },
    {
      $Type: 'UI.ReferenceFacet',
      ID: 'AuditSection',
      Label: '{i18n>SystemAudit}',
      Target: '@UI.FieldGroup#AuditData'
    }
  ],

  // Grupos de Campos (FieldGroups) para el Object Page
  UI.FieldGroup #TechnicalData: {
    Data: [
      { Value: code, Label: '{i18n>IdentifierCode}' },
      { Value: name, Label: '{i18n>NameOfEquipment}' },
      { Value: model, Label: '{i18n>ManufacturerModel}' },
      { Value: serialNumber, Label: '{i18n>SerialNumber}' },
      { Value: category_code, Label: '{i18n>Category}' },
      { Value: manufactureYear, Label: '{i18n>ManufactureYear}' },
      { Value: imageUrl, Label: '{i18n>ImageUrl}' }
    ]
  },

  UI.FieldGroup #OperationData: {
    Data: [
      { Value: status_code, Label: '{i18n>OperatingStatus}' },
      { Value: location, Label: '{i18n>MineSiteLocation}' },
      { Value: operatingHours, Label: '{i18n>OperatingHours}' },
      { Value: healthScore, Label: '{i18n>HealthIndex}' },
      { Value: dailyRate, Label: '{i18n>DailyRate}' },
      { Value: currency_code, Label: '{i18n>Currency}' },
      { Value: lastServiceDate, Label: '{i18n>LastServicePerformed}' },
      { Value: nextServiceDate, Label: '{i18n>NextScheduledService}' }
    ]
  },

  UI.FieldGroup #AuditData: {
    Data: [
      { Value: createdAt, Label: '{i18n>CreatedOn}' },
      { Value: createdBy, Label: '{i18n>CreatedBy}' },
      { Value: modifiedAt, Label: '{i18n>LastModified}' },
      { Value: modifiedBy, Label: '{i18n>ModifiedBy}' }
    ]
  }

);

// ---------------------------------------------------------------------------
// Entidad Detalle: MaintenanceLogs (Tabla hija en Object Page)
// ---------------------------------------------------------------------------
annotate FleetService.MaintenanceLogs with @(

  UI.HeaderInfo: {
    TypeName: '{i18n>MaintenanceOrder}',
    TypeNamePlural: '{i18n>MaintenanceOrders}',
    Title: { Value: logNumber }
  },

  UI.LineItem: [
    {
      $Type: 'UI.DataField',
      Value: logNumber,
      Label: '{i18n>OrderNo}'
    },
    {
      $Type: 'UI.DataField',
      Value: serviceDate,
      Label: '{i18n>ServiceDate}'
    },
    {
      $Type: 'UI.DataField',
      Value: maintenanceType,
      Label: '{i18n>MaintType}'
    },
    {
      $Type: 'UI.DataField',
      Value: technician,
      Label: '{i18n>ResponsibleTechnician}'
    },
    {
      $Type: 'UI.DataField',
      Value: hoursSpent,
      Label: '{i18n>HoursSpent}'
    },
    {
      $Type: 'UI.DataField',
      Value: cost,
      Label: '{i18n>Cost}'
    },
    {
      $Type: 'UI.DataField',
      Value: status,
      Label: '{i18n>Status}',
      Criticality: criticality
    },
    {
      $Type: 'UI.DataField',
      Value: remarks,
      Label: '{i18n>TechnicalRemarks}'
    }
  ],

  UI.Facets: [
    {
      $Type: 'UI.ReferenceFacet',
      Label: '{i18n>OrderDetails}',
      Target: '@UI.FieldGroup#LogDetail'
    }
  ],

  UI.FieldGroup #LogDetail: {
    Data: [
      { Value: logNumber, Label: '{i18n>OrderNo}' },
      { Value: serviceDate, Label: '{i18n>ExecutionDate}' },
      { Value: maintenanceType, Label: '{i18n>MaintenanceType}' },
      { Value: technician, Label: '{i18n>SpecialistTechnician}' },
      { Value: hoursSpent, Label: '{i18n>HoursWorked}' },
      { Value: cost, Label: '{i18n>ServiceCost}' },
      { Value: currency_code, Label: '{i18n>Currency}' },
      { Value: status, Label: '{i18n>OrderStatus}' },
      { Value: remarks, Label: '{i18n>DetailsAndRemarks}' }
    ]
  }

);
