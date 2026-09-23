using { sap.komatsu as my } from '../db/schema';

@path: '/fleet'
@requires: 'authenticated-user'
service FleetService {

  @odata.draft.enabled
  entity Equipments as projection on my.Equipments;

  entity MaintenanceLogs as projection on my.MaintenanceLogs;

  @readonly
  entity Categories as projection on my.Categories;

  @readonly
  entity Statuses as projection on my.Statuses;

}

// Cargar anotaciones UI para Fiori Elements
using from './annotations';
