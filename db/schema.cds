namespace sap.komatsu;

using { cuid, managed, Currency } from '@sap/cds/common';

/**
 * Entidad Principal: Equipos y Maquinaria Pesada (Komatsu Fleet)
 */
entity Equipments : cuid, managed {
  code            : String(20) @title: '{i18n>EquipmentCode}';
  name            : String(100) @title: '{i18n>NameOfEquipment}';
  model           : String(50) @title: '{i18n>Model}';
  serialNumber    : String(50) @title: '{i18n>SerialNumber}';
  category        : Association to Categories @title: '{i18n>Category}';
  status          : Association to Statuses @title: '{i18n>OperatingStatus}';
  healthScore     : Integer @title: '{i18n>HealthIndex}';
  operatingHours  : Integer @title: '{i18n>OperatingHours}';
  location        : String(100) @title: '{i18n>LocationSite}';
  supervisorName  : String(100) @title: '{i18n>SupervisorInCharge}';
  supervisorEmail : String(100) @title: '{i18n>SupervisorEmail}';
  supervisorPhone : String(50) @title: '{i18n>SupervisorPhone}';
  dailyRate       : Decimal(10,2) @title: '{i18n>DailyRate}';
  currency        : Currency @title: '{i18n>Currency}';
  manufactureYear : Integer @title: '{i18n>ManufactureYear}';
  lastServiceDate : Date @title: '{i18n>LastMaintenance}';
  nextServiceDate : Date @title: '{i18n>NextMaintenance}';
  imageUrl        : String(255) @title: '{i18n>ReferenceImage}';
  
  // Composición 1 a muchos: Órdenes e historial de mantenimiento
  maintenanceLogs : Composition of many MaintenanceLogs on maintenanceLogs.equipment = $self;
}

/**
 * Entidad Detalle: Registro de Mantenimientos y Órdenes de Trabajo
 */
entity MaintenanceLogs : cuid, managed {
  equipment       : Association to Equipments;
  logNumber       : String(20) @title: '{i18n>WorkOrderNo}';
  serviceDate     : Date @title: '{i18n>DateOfService}';
  maintenanceType : String(40) @title: '{i18n>MaintenanceType}'; // Preventivo, Correctivo, Overhaul
  technician      : String(100) @title: '{i18n>ResponsibleTechnician}';
  hoursSpent      : Decimal(5,2) @title: '{i18n>HoursSpent}';
  cost            : Decimal(10,2) @title: '{i18n>Cost}';
  currency        : Currency @title: '{i18n>Currency}';
  status          : String(30) @title: '{i18n>OrderStatus}'; // Completado, En Proceso, Programado
  criticality     : Integer @title: '{i18n>Criticality}'; // 3: Completado, 2: En Proceso, 1: Programado/Crítico
  remarks         : LargeString @title: '{i18n>TechnicalRemarks}';
}

/**
 * Entidad Maestra / Value Help: Categorías de Maquinaria
 */
entity Categories {
  key code        : String(20) @title: '{i18n>CategoryCode}';
  name            : localized String(60) @title: '{i18n>Name}';
  description     : localized String(200) @title: '{i18n>Description}';
}

/**
 * Entidad Maestra / Value Help: Estados Operativos con Criticidad Semántica
 */
entity Statuses {
  key code        : String(20) @title: '{i18n>StatusCode}';
  name            : localized String(60) @title: '{i18n>Description}';
  criticality     : Integer @title: '{i18n>SemanticCriticality}'; // 3 = Verde (Success), 2 = Amarillo (Warning), 1 = Rojo (Danger)
}
