# Komatsu Fleet Management - CAP OData V4 Service & Fiori Elements Backend

Este proyecto es una aplicación **SAP Cloud Application Programming Model (CAP)** en Node.js que expone un servicio **OData V4 (`FleetService`)** diseñado específicamente para demostraciones de **SAP Business Application Studio (BAS)** y **SAP Fiori Elements (List Report / Object Page)**.

---

## 🚜 Modelo de Negocio Incluido

- **`Equipments` (Entidad Principal con `@odata.draft.enabled`)**:
  - Código, Modelo, Número de Serie, Categoría, Estado Operativo con criticidad de color.
  - Horas de Operación, Índice de Salud (%), Tarifa Diaria con Moneda (USD), Faena/Ubicación.
  - Datos de contacto del Supervisor a Cargo (Email, Teléfono).
- **`MaintenanceLogs` (Composición 1 a N - Detalle)**:
  - Órdenes de trabajo, fecha, tipo de mantenimiento, técnico especialista, horas, costo, criticidad y observaciones.
- **`Categories` y `Statuses`**: Listas maestras asociadas para soporte de *Value Helps* (desplegables) automáticos en Fiori Elements.

---

## ⚡ Cómo Ejecutar Localmente

1. Instalar dependencias (ya instaladas):
   ```bash
   npm install
   ```

2. Iniciar el servidor CAP:
   ```bash
   npm start
   # o bien:
   npx @sap/cds-dk watch
   ```

3. Acceder al servicio:
   - **Página de inicio CAP**: [http://localhost:4004](http://localhost:4004)
   - **Metadatos OData V4**: [http://localhost:4004/fleet/$metadata](http://localhost:4004/fleet/$metadata)
   - **Entidad Equipos**: [http://localhost:4004/fleet/Equipments](http://localhost:4004/fleet/Equipments)

---

## 📖 Guía para la Demostración en BAS

Consulta la guía paso a paso completa con el guión para la clase en:
👉 **[DEMO_GUIDE.md](./DEMO_GUIDE.md)**
