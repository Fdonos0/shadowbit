# Shadowbit (SHB) – Fork de Monero

**Shadowbit** es una criptomoneda basada en el código de [Monero](https://www.getmonero.org/), centrada en la privacidad, descentralización y adaptada para fines educativos, de prueba o desarrollo.

Este proyecto ha sido modificado para funcionar en **testnet** y está diseñado para ejecutarse fácilmente en una **Raspberry Pi 4** o cualquier sistema compatible, gracias a la integración con **Docker** y **Docker Compose**.

---

## Características

- Fork completo de Monero
- Nombre de la moneda: `Shadowbit`
- Símbolo/Ticker: `SHB`
- Puertos personalizados para evitar conflictos con Monero:
  - P2P: `28080`
  - RPC: `28081`
- Scripts de instalación automatizada
- Compatible con Raspberry Pi 4

---

## Requisitos

- Git
- Docker
- Docker Compose
- Raspberry Pi 4 con Ubuntu Server o cualquier Linux compatible

---

## Instalación rápida

1. **Clonar el repositorio:**

```bash
git clone https://github.com/Fdonos0/shadowbit.git
cd shadowbit