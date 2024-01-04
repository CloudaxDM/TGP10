#version=""
#archivo_local="TGP10-$version.tar"
clear
pkill -o chrome || true

echo "###################"
echo "###TGP10#updater###"
echo "#######ByMax#######"
echo "###################"
echo
echo
echo
echo "NOTA: Una vez se aplique la actualizacion, es necesario reconfigurar el kiosko ejecutando: 'config_kiosk' o 'kiosk-with-agent'"
echo
echo "Es necesario activar permisos de superusuario"
read -r -p "Presiona INTRO para continuar" key

# Variables
USER="CloudaxDM"
REPO="TGP10"

# Hacer la solicitud a la API de GitHub y guardar la respuesta en un archivo temporal
curl -s "https://api.github.com/repos/$USER/$REPO/releases" > temp_response.json

# Verificar si la solicitud fue exitosa
if [ $? -ne 0 ]; then
  echo "Error al hacer la solicitud a la API de GitHub"
  echo "se buscará si hay fichero local"
fi

# Obtener las últimas versiones
echo "Últimas versiones de $REPO:"
versions=$(grep -o '"tag_name": *"[^"]*"' temp_response.json | cut -d '"' -f 4 | awk -F'-' '{print $2}')
echo "$versions"


# Solicitar al usuario que introduzca la versión
read -p "Introduce la versión que deseas descargar: " selected_version

# Modificar la variable 'version' con la versión seleccionada por el usuario
version=$selected_version
archivo_local="TGP10-$version.tar"

echo "Descargando la versión $version..."

# Eliminar el archivo temporal
rm temp_response.json




# Verificar si el archivo local existe en la carpeta actual
if [ -e "$archivo_local" ]; then
    echo "El archivo local $archivo_local ya existe. Continuando..."
else
    echo "El archivo local $archivo_local no existe. Descargando desde GitHub..."
    # Descargar el archivo desde GitHub si no existe localmente
    wget "https://github.com/CloudaxDM/TGP10/releases/download/TGP10-$version/$archivo_local"
fi

sleep 5
clear
echo "Se va a actualizar el TGP10 a la version $version"
echo
read -r -p "Presiona INTRO para continuar" key


sleep 10

echo
echo "#############################"
sudo tar xvf TGP10-$version.tar
echo "#############################"
echo
sleep 3
clear

echo "Se va a proceder a borrar los ficheros antiguos..."
sleep 3
echo
echo "#############################"
sudo rm /home/qmatic/agentbrowser.sh
sudo rm /home/qmatic/infoticket.sh
sudo rm /home/qmatic/new.html
sudo rm /home/qmatic/programacionpantalla.sh
sudo rm /home/qmatic/wait.html

sudo rm /usr/local/bin/config_kiosk
sudo rm /usr/local/bin/kiosk-with-agent
sudo rm /usr/local/bin/programar-pantalla
echo "#############################"
echo
echo "Borrando..."
sleep 2
echo "25%"
sleep 1
echo "50%"
sleep 2
echo "75%"
sleep 2
echo "100%"
sleep 2
echo
echo "Borrado completado"
sleep 3
clear
echo "Se van a instalar las nuevas versiones..."
sleep 2
echo "Instalando.."
sudo chown -R qmatic updater/qmatic
sudo chown -R qmatic updater/bin
sudo chmod -R 755 updater/bin
sudo chmod -R 755 updater/qmatic
sudo cp updater/qmatic/* /home/qmatic/
sudo cp updater/bin/* /usr/local/bin/

echo 

sleep 2
echo "25%"
sleep 1
echo "50%"
sleep 2
echo "75%"
sleep 2
echo "100%"

sleep 3
echo
sleep 1


sudo tee /etc/acpi/events/power >/dev/null <<EOF
event=button/power PBTN 00000080 00000000
action=sudo -u qmatic /bin/bash /home/qmatic/infoticket.sh &
EOF

sudo systemctl restart acpid

echo "Reconfigurando botón de eventos"
echo "Instalacion finalizada"
echo
echo
echo "#########"
echo "ATENCION!"
echo
echo "ES NECESARIO RECONFIGURAR EL KIOSKO LANZANDO 'config_kiosk' o 'kiosk-with-agent'"
echo "#########"
echo

sudo rm -Rf updater
sudo chown -R qmatic /home/qmatic
sudo chown -R qmatic /usr/local/bin
read -r -p "Presiona INTRO para continuar" key

