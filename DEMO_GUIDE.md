# Guía de Demostración: SAP Business Application Studio (BAS) & Fiori Elements

Esta guía detalla el paso a paso para realizar la **Demostración A: SAP Business Application Studio (BAS) y Fiori Elements (Capítulos 2, 5 y 7)** utilizando este backend CAP enriquecido de **Gestión de Flota y Maquinaria Pesada Komatsu**.

---

## 🎯 Objetivo Pedagógico de la Demostración

Mostrar en vivo cómo **SAP Fiori Elements**:
1. **Minimiza el código frontend a 0 líneas**: Toda la interfaz de usuario se genera e infiere a partir de metadatos y anotaciones OData backend (`@UI.*`).
2. **Garantiza consistencia visual y diseño empresarial**: Patrones visuales estándar SAP (List Report / Object Page).
3. **Ofrece capacidades avanzadas out-of-the-box**:
   - Barra de filtros interactiva con *Value Helps* (listas de ayuda).
   - Semántica visual de criticidad (estados en Verde, Amarillo, Rojo).
   - Páginas de objeto con cabeceras de KPIs (DataPoints) y tarjetas de contacto.
   - Navegación maestro-detalle con tablas secundarias (Composición 1 a N con órdenes de mantenimiento).
   - Soporte nativo de borradores (*Draft Handling*) con botones automáticos de Crear, Editar, Guardar y Cancelar.

---

## 🛠️ Paso 1: Levantar el Backend OData (Local o en BAS)

En la terminal integrada de BAS (o local en VS Code):
```bash
cds watch
```
*(o `npm start`)*

Verás en la consola:
```text
[cds] - connect to db > sqlite { url: ':memory:' }
  > init from db/data/sap.komatsu-Statuses.csv 
  > init from db/data/sap.komatsu-MaintenanceLogs.csv 
  > init from db/data/sap.komatsu-Equipments.csv 
  > init from db/data/sap.komatsu-Categories.csv 
/> successfully deployed to in-memory database.

[cds] - serving FleetService { at: '/fleet' }
[cds] - server listening on { url: 'http://localhost:4004' }
```

> **Verificación rápida**: Abre `http://localhost:4004/fleet/$metadata` para ver las anotaciones OData V4 listas.

---

## 🚀 Paso 2: Generar la App Fiori Elements en BAS

1. **Abrir el Generador de Plantillas**:
   - Presiona `F1` (o `Ctrl + Shift + P`) en BAS.
   - Escribe y selecciona: `Fiori: Open Application Generator`.

2. **Paso 1 del Wizard - Template Selection**:
   - Template: **SAP Fiori elements**
   - Floorplan: **List Report Page** (o *List Report Object Page*)
   - Clic en **Next**.

3. **Paso 2 del Wizard - Data Source and Service Selection**:
   - Data source: **Use a Local CAP Project** (si estás en el mismo workspace) o **Connect to an OData Service**.
   - Si eliges *Use a Local CAP Project*:
     - Choose CAP project: Selecciona la carpeta de `cap-demo`.
     - OData service: Selecciona **FleetService (/fleet)**.
   - Clic en **Next**.

4. **Paso 3 del Wizard - Entity Selection**:
   - Main entity: **Equipments**
   - Navigation entity (opcional pero muy recomendado para mostrar el Object Page): **maintenanceLogs**
   - Clic en **Next**.

5. **Paso 4 del Wizard - Project Attributes**:
   - Module name: `komatsufleet`
   - Application title: `Gestión de Flota y Maquinaria Pesada Komatsu`
   - Description: `App Fiori Elements generada 100% por anotaciones backend`
   - Clic en **Finish**.

---

## 🎬 Paso 3: Guión de la Presentación en Vivo (Qué mostrar a la clase)

### 1. El List Report (Página Principal)
* **Barra de Filtros (`@UI.SelectionFields`)**:
  - Muestra cómo sin programar nada en JavaScript, Fiori generó filtros por **Categoría**, **Estado Operativo** y **Ubicación / Faena**.
  - Abre el Value Help de **Categoría**: se abre un diálogo modal con las categorías reales (Excavadoras, Bulldozers, Camiones, etc.).
  - Haz clic en **Go** / **Buscar** para cargar los datos.
* **Tabla de Resultados (`@UI.LineItem`)**:
  - Resalta las columnas automáticas: Código, Nombre de equipo, Categoría, Horas de operación, Tarifa Diaria en USD (`@Measures.ISOCurrency`).
  - **Criticidad Semántica (Lo más vistoso)**:
    - Muestra los chips de estado: *Operativo* en verde, *En Mantenimiento* en amarillo y *Falla Crítica* en rojo.
    - Explica: *"El backend solo envió un código numérico (1, 2, 3) asociado a la criticidad, y Fiori Elements aplicó el estándar de diseño visual de SAP automáticamente"*.

### 2. La Object Page (Página de Detalle)
* Haz clic en cualquier equipo (por ejemplo, `EQ-EXC-001` o `EQ-BUL-002`):
* **Cabecera (`@UI.HeaderFacets` y `@UI.DataPoint`)**:
  - Muestra los indicadores clave en la parte superior: Estado Actual (con color), Horas Acumuladas, Índice de Salud (%) y Tarifa Diaria.
  - Muestra la tarjeta de contacto del **Supervisor a Cargo** con su email y teléfono.
* **Secciones y Pestañas (`@UI.Facets`)**:
  - Sección **Información del Equipo**: Dividida en dos grupos (*Ficha Técnica* y *Operación y Faena*).
  - Sección **Historial y Órdenes de Mantenimiento**:
    - Es la relación 1 a N con la entidad hija `MaintenanceLogs`.
    - Muestra las órdenes de trabajo con técnico asignado, horas, costo y criticidad de la orden.
  - Sección **Auditoría del Sistema**:
    - Campos gestionados automáticamente por CAP (`createdAt`, `createdBy`, etc.).

### 3. La Magia de Draft (`@odata.draft.enabled`)
* Haz clic en el botón **Edit** / **Editar** en la esquina superior derecha:
  - Explica: *"Fiori Elements activa el modo borrador. Si cambio un dato y cierro el navegador, los cambios no se pierden ni bloquean la base de datos para otros usuarios"*.
  - Modifica las horas o la ubicación y presiona **Save** / **Guardar**.
* Vuelve al List Report y presiona **Create** / **Crear**:
  - Muestra el formulario de alta generado automáticamente.

---

## 💡 Mensajes Clave para Concluir la Demostración

1. **Productividad Extrema**: Un desarrollo tradicional UI5 de esta pantalla tomaría días o semanas; con CAP + Fiori Elements toma **5 minutos**.
2. **Mantenibilidad Centralizada**: Si agregamos un campo o cambiamos una validación en el backend, la interfaz se adapta automáticamente.
3. **Cumplimiento de Estándares SAP**: La app sigue estrictamente las directrices de Fiori Design Guidelines sin esfuerzo adicional.
