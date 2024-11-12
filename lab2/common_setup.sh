# common_setup.sh

# Обновление и установка необходимых пакетов
sudo apt update
#  && sudo apt upgrade -y
sudo apt install -y curl apt-transport-https git iptables-persistent

# Отключаем swap
sudo swapoff -a
sudo sed -i '/swap.img/d' /etc/fstab

# Загрузка модулей ядра
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
overlay
EOF

sudo modprobe br_netfilter
sudo modprobe overlay

# Проверка работы модулей
sudo lsmod | egrep "br_netfilter|overlay"

# Настройка параметров ядра
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
