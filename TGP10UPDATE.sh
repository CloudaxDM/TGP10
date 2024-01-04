version="3.5"
archivo_local="TGP10-$version.tar"
clear
pkill -o chrome || true

echo "###################"
echo "###TGP10#updater###"
echo "#######ByMax#######"
echo "###################"
echo
echo
echo "Se va a actualizar el TGP10 a la version $version"
echo
echo "NOTA: Una vez se aplique la actualizacion, es necesario reconfigurar el kiosko ejecutando: 'config_kiosk' o 'kiosk-with-agent'"
echo
echo "Es necesario activar permisos de superusuario"
read -r -p "Presiona INTRO para continuar" key

# Verificar si el archivo local existe en la carpeta actual
if [ -e "$archivo_local" ]; then
    echo "El archivo local $archivo_local ya existe. Continuando..."
else
    echo "El archivo local $archivo_local no existe. Descargando desde GitHub..."
    # Descargar el archivo desde GitHub si no existe localmente
    wget "https://github.com/CloudaxDM/TGP10/releases/download/TGP10-$version/$archivo_local"
fi
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

sudo cat << EOF > /etc/acpi/events/power
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

read -r -p "Presiona INTRO para continuar" key

