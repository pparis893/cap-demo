namespace sap.komatsu;

using { cuid, managed, Currency } from '@sap/cds/common';

/**
 * Entidad Principal: Equipos y Maquinaria Pesada (Komatsu Fleet)
 */
entity Equipments : cuid, managed {
  code            : String(20) @title: 'Código Equipo';
  name            : String(100) @title: 'Nombre del Equipo';
  model           : String(50) @title: 'Modelo';
  serialNumber    : String(50) @title: 'Número de Serie';
  category        : Association to Categories @title: 'Categoría';
  status          : Association to Statuses @title: 'Estado Operativo';
  healthScore     : Integer @title: 'Índice de Salud (%)';
  operatingHours  : Integer @title: 'Horas de Operación';
  location        : String(100) @title: 'Ubicación / Faena';
  supervisorName  : String(100) @title: 'Supervisor a Cargo';
  supervisorEmail : String(100) @title: 'Correo Supervisor';
  supervisorPhone : String(50) @title: 'Teléfono Supervisor';
  dailyRate       : Decimal(10,2) @title: 'Tarifa Diaria';
  currency        : Currency @title: 'Moneda';
  manufactureYear : Integer @title: 'Año de Fabricación';
  lastServiceDate : Date @title: 'Último Mantenimiento';
  nextServiceDate : Date @title: 'Próximo Mantenimiento';
  imageUrl        : String(255) @title: 'Imagen Referencial';
  
  // Composición 1 a muchos: Órdenes e historial de mantenimiento
  maintenanceLogs : Composition of many MaintenanceLogs on maintenanceLogs.equipment = $self;
}

/**
 * Entidad Detalle: Registro de Mantenimientos y Órdenes de Trabajo
 */
entity MaintenanceLogs : cuid, managed {
  equipment       : Association to Equipments;
  logNumber       : String(20) @title: 'N° Orden de Trabajo';
  serviceDate     : Date @title: 'Fecha de Servicio';
  maintenanceType : String(40) @title: 'Tipo de Mantenimiento'; // Preventivo, Correctivo, Overhaul
  technician      : String(100) @title: 'Técnico Responsable';
  hoursSpent      : Decimal(5,2) @title: 'Horas Invertidas';
  cost            : Decimal(10,2) @title: 'Costo';
  currency        : Currency @title: 'Moneda';
  status          : String(30) @title: 'Estado de la Orden'; // Completado, En Proceso, Programado
  criticality     : Integer @title: 'Criticidad'; // 3: Completado, 2: En Proceso, 1: Programado/Crítico
  remarks         : LargeString @title: 'Observaciones Técnicas';
}

/**
 * Entidad Maestra / Value Help: Categorías de Maquinaria
 */
entity Categories {
  key code        : String(20) @title: 'Código Categoría';
  name            : String(60) @title: 'Nombre';
  description     : String(200) @title: 'Descripción';
}

/**
 * Entidad Maestra / Value Help: Estados Operativos con Criticidad Semántica
 */
entity Statuses {
  key code        : String(20) @title: 'Código Estado';
  name            : String(60) @title: 'Descripción';
  criticality     : Integer @title: 'Criticidad Semántica'; // 3 = Verde (Success), 2 = Amarillo (Warning), 1 = Rojo (Danger)
}
