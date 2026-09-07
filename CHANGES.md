# Release Notes: 

- Ya puedes mandar mensaje a cualquier app de mensajería que tengas instalada en tu celular. Selecciona la opción "Otros" en la sección de "Mensajes" en el menú de configuración.

- Puedes mandar mensaje de cualquier ubicación en la que te encuentres. Busca en la pantalla principal la opción de "Usar ubicación personalizada". Podrás escribir tu propia "Ubicación manual", "Usar el mapa" para elegir especificamente en dónde te encuentras o "Usar ubicación actual". 

- Podrás consultar todas las estaciones y ubicaciones personalizadas en el "Historal" , solopresioa en el pequeño librito d ela esquina superior derecha, y no solo podrás visualizar en categorías las estaciones, también podrás reenviar el mensaje y visualizar de que transporte y línea pertence, o de que tipo es.

- El selector ha agrandado su tamaño, asi como se han globalizado los colores de los Headers con fonr del Metro, y se agregaron otros ligeros cambios en el diseño de la app

-----------------------

# Cambios en el código

- Se crea la pantalla de custom_location_screen, asi como se agregan sus componentes: custom_location_icons , custom_location_items , custom_location_layout

- Se crea la history_screen, asi como se programaron sus configuraciones correspondientes en preferences_services.dart , todas tienen de nombre "history"

- Se extrae la función que permite mandar mensajes a las distintas apps permitidas, en un archivo: send_message_helper

- Se crea un helper para el lanzamiento de diálogos según el sistema operativo en el que te encuentres 

- Los layouts de la app estan ahora en su propia carpeta, adentro del directorio: widgets

- Se crea una plantilla para pantallas nuevas

- Se añade el map_screen , el cual es el mapa mostrado al seleccionar la configuración de "usar el mapa"

- Se añaden los archivos del history... y keyboard_return... buttons en el directorio correspondiente a los botones.
