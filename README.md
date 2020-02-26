# cli_app

Ejercicio Backend Shipnow

Desarrolla una consola simple para manejar archivos y carpetas ingresando comandos por teclado, similar a Bash, por ejemplo.
Todos los recursos deben ser mantenidos en memoria y no persistidos a disco. Los archivos no necesita tener extensión pero deben tener metadata (la información de la metadata queda a tu criterio).

La forma recomendada para entrar a la consola desde el SO es:

ruby consola.rb

Comandos que soporta la consola:

	- Archivos y carpetas

		create_file file_1 "Contenido" : Crear un archivo con un contenido

		show file_1: Ver el contenido de un archivo

		metadata file_1: Ver la metadata de un archivo

		create_folder folder_1: Crear una carpeta

		cd folder_1: Entrar a una carpeta

		cd ..: Volver una carpeta para atrás:

		destroy file_1, destroy folder_1: Eliminar archivo o carpeta

		ls: Ver contenido de la carpeta actual

		whereami: Obtener la ruta de la carpeta actual

	- Usuarios y permisos

		La consola no tiene seguridad por lo que se puede implementar un sistema de usuarios con varios roles:

		Superusuarios (super): pueden leer y crear archivos. También son los únicos que pueden crear y eliminar usuarios.

		Usuarios normales (regular): pueden leer y crear archivos y pueden editar su propia contraseña.

		Usuarios de solo lectura (read_only): solo pueden leer los archivos existentes. No pueden editar su	propia contraseña.

		create_user username password -role=ready_only: Crear un usuario nuevo como superusuario

		update_password new_password: Actualizar contraseña del usuario actual

		destroy_user username: Remover usuarios como superusuario

		login username password: Loguearte como usuario

		whoami: Obtener nombre del usuario actual


	- Espacios de trabajo

	Por defecto los archivos, las carpetas y los usuarios se mantienen solo en memoria, por lo que deben generarse de nuevo al empezar la aplicación y se eliminan al salir.

	Una mejora a la consola es poder darle un parámetro a la consola cuando la inicias para que funcione con persistencia automática a un archivo.

	El formato para persistir la data queda a tu criterio.

	Una posible forma de acceder a este modo desde el SO: ruby consola.rb -persisted file