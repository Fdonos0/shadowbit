#!/bin/bash
set -e

# VARIABLES PERSONALIZABLES
COIN_NAME="Shadowbit"
COIN_TICKER="SHB"
GIT_URL="https://github.com/Fdonos0/shadowbit"
FORK_NAME="shadowbit-src"

echo "🔧 Instalando dependencias..."
sudo apt update && sudo apt install -y \
  build-essential cmake pkg-config libtool autoconf automake \
  libssl-dev libunbound-dev libsodium-dev libboost-all-dev \
  libzmq3-dev libprotobuf-dev protobuf-compiler libminiupnpc-dev \
  libreadline-dev libldns-dev libexpat1-dev doxygen graphviz

# 1. Clonar el repositorio limpio
rm -rf "$FORK_NAME"
echo "📥 Clonando repositorio Shadowbit..."
git clone --recursive "$GIT_URL" "$FORK_NAME"
cd "$FORK_NAME"

# 2. Forzar actualización de submódulos
echo "🔁 Verificando submódulos..."
git submodule deinit -f .
git submodule update --init --recursive --force

# 3. Renombrar proyecto (evitando archivos sensibles)
echo "✏️ Renombrando variables del proyecto..."
find . -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -o -name "*.c" -o -name "*.txt" -o -name "CMakeLists.txt" \) \
  ! -path "./external/*" ! -path "./src/device_trezor/*" \
  -exec sed -i "s/\bMonero\b/$COIN_NAME/g" {} +

find . -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -o -name "*.c" -o -name "*.txt" -o -name "CMakeLists.txt" \) \
  ! -path "./external/*" ! -path "./src/device_trezor/*" \
  -exec sed -i "s/\bmonero\b/shadowbit/g" {} +

find . -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -o -name "*.c" -o -name "*.txt" -o -name "CMakeLists.txt" \) \
  ! -path "./external/*" ! -path "./src/device_trezor/*" \
  -exec sed -i "s/\bXMR\b/$COIN_TICKER/g" {} +

# 4. Restaurar funciones que no deben cambiarse
echo "🛠️ Corrigiendo funciones internas..."
find . -type f -name "CMakeLists.txt" -exec sed -i 's/shadowbit_crypto_autodetect/monero_crypto_autodetect/g' {} +
find . -type f -name "CMakeLists.txt" -exec sed -i 's/shadowbit_enable_coverage/monero_enable_coverage/g' {} +
find . -type f -name "CMakeLists.txt" -exec sed -i 's/shadowbit_find_all_headers/monero_find_all_headers/g' {} +

# 5. Cambiar puertos default para evitar conflictos
echo "📡 Cambiando puertos default..."
find . -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.txt" \) \
  ! -path "./external/*" \
  -exec sed -i 's/18080/28080/g' {} +
find . -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.txt" \) \
  ! -path "./external/*" \
  -exec sed -i 's/18081/28081/g' {} +
find . -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.txt" \) \
  ! -path "./external/*" \
  -exec sed -i 's/18082/28082/g' {} +

# 6. Compilar el proyecto
echo "⚙️ Compilando Shadowbit..."
mkdir -p build && cd build
cmake -D BUILD_TESTS=OFF -D CMAKE_BUILD_TYPE=Release ..
make -j$(nproc)

# 7. Resultado final
echo -e \"\\n✅ $COIN_NAME listo para usar. Ejecuta:\\n\"
echo \"  ./build/bin/shadowbitd --testnet\"
echo \"  ./build/bin/shadowbit-wallet-cli --testnet\"
