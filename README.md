#### 1\. INFORMACIÓN INICIAL

- **Autor:** Mex Lozano Rafael Emilio
- **Título del proyecto:** ¡Anuncia mi llegada!

#### 2\. RESUMEN DEL PROYECTO, METAS Y OBJETIVOS

- **Resumen:**  
    ¡Anuncia mi llegada! Es una aplicación que le permite al usuario mandar un mensaje de texto a sus contactos de que a llegado a una estación de la red de movilidad integrada de la Ciudad de México o del Estado de México. 
- **Metas:**  
    * Crear una interfaz intuitiva que permita moverse entre la aplicación de forma fluida y eficiente.
    * Permitirle a los usuarios de la red de movilidad integrada una comunicación instántanea al momento de realizar el ascenso o el descenso de las estaciones de este sistema.
- **Objetivos:**
    * Lanzar el MVP antes del 10 de Agosto del 2026.
#### 3\. PÚBLICO OBJETIVO (UX)
Sectores de la población que son usuarios constantes de la red de movilidad integrada de la Ciudad de México y del Estado de México. 
#### 4\. PROPÓSITO Y ALCANCE

- **En alcance (Entregables):**  
    + Utilizar la aplicación como usuario receptor o remitente.
    + Registrarse mediante un correo electrónico.
    + Crear un usuario y contraseña para ingresar a la aplicación.

    + Usuario remitente.
        + Crear hasta 5 rutas de las estaciones que ocupan del Metro. 
        + Permitir que la aplicación mande el mensaje de que ya llegada a la estación. 
        + Decidir que estaciones serán en las que se mandará el mensaje de llegada a la estación.
        * Personalizar el mensaje de llegada a la estación.
        + Obtener su localización mediante el GPS.
        + Decidir quien será el receptor de sus mensajes de llegada a la estación
        + Iniciar el rastreo de su ruta.

    + Usuario receptor.
        + Autorizar ser el receptor del usuario remitente que lo eligió.
        + Recibir el mensaje de llegada del usuario remitente. 
        + Revisar la ruta en tiempo real del usuario remitente.
- **Fuera de alcance:**
    + Utilizar la aplicación como usuario receptor o remitente al mismo tiempo.
    + Registrarse mediante su número telefónico.

    + Usuario remitente.
        + Crear hasta 5 rutas con las estaciones o paradas de los medios de transporte de todo el sistema de la Movilidad Integrada.
        + Decidir si la aplicación mandará automáticamente el mensaje de llegada a la estación o parada.

    + Usuario receptor.
        + Permitir que el mensaje de llegada del remitente se mande a la aplicación de Mensajes predeterminada de su celular.
#### 5\. ESPECIFICACIONES FUNCIONALES

\\

#### 6\. REQUISITOS NO FUNCIONALES
| Categoría | Requisito |
| :---- | :---- |
| **Rendimiento** | Tiempo de carga inicial rápido (LCP). |
| **Accesibilidad** | La aplicación debe ser navegable mediante teclado y lectores de pantalla. |
| **Universabilidad** | La aplicación podrá ser ocupada en los sistemas operativos de iOS y Android |
| **Seguridad** | Toda la información del usuario debe estar encriptada. |
#### 7\. ARQUITECTURA DE LA INFORMACIÓN Y UX

\

#### 8\. ESPECIFICACIONES TÉCNICAS

- **Frontend:** Flutter, framework multiplataforma que permite otorgar a la aplicación una interfaz moderna.
- **Backend:** Dart, lenguaje de programación multiplataforma que permite crear un solo código y ejecutarlo en sistemas iOS y Android
- **Base de Datos:** MySQL ya que su integrción con Flutter y Dart es sencila, además de proporcionar una base de datos segura y estable. 

