WalletConnect V5 - Smart Tip System
Este contrato inteligente, desarrollado en Clarity para la blockchain de Stacks, es un sistema avanzado de propinas e interacción para dApps. Está diseñado específicamente para integrarse con AppKit (Reown/WalletConnect), permitiendo una experiencia de usuario fluida y con lógica de fidelización on-chain.

📋 Características Principales
Sistema de Propinas (STX): Permite el envío de STX de forma segura entre wallets.

Lógica de Usuario VIP: Clasifica automáticamente a los usuarios como VIP si superan un umbral de 10 STX acumulados.

Estadísticas On-Chain: Rastrea el número de transacciones y el monto total aportado por cada dirección.

Control de Pausa (Circuit Breaker): El administrador puede pausar el contrato en caso de mantenimiento o emergencia.

Optimizado para Frontends: Incluye funciones de lectura (read-only) que devuelven perfiles completos de usuario en una sola llamada.

🛠️ Funcionalidad Técnica
1. Variables y Estado
owner-address: Almacena la dirección del creador del contrato (administrador).

contract-paused: Un booleano que determina si las funciones públicas están activas.

user-data: Un mapa que guarda un registro histórico (contador y monto) de cada wallet.

vips: Un mapa de booleanos para acceso rápido al estado VIP.

2. Funciones de Escritura (Public)
send-tip: La función estrella. Recibe un destinatario y una cantidad. Valida el estado del contrato, realiza la transferencia de STX, actualiza los mapas de usuario y verifica si el usuario ha alcanzado el estatus VIP.

toggle-pause: Función de seguridad restringida al dueño del contrato para activar/desactivar el funcionamiento.

3. Funciones de Lectura (Read-Only)
get-user-info: Devuelve un objeto con las estadísticas del usuario y si es VIP. Ideal para mostrar "badges" en el frontend.

get-global-stats: Devuelve el balance total gestionado por el contrato y su estado actual.

🚀 Cómo empezar
Requisitos
Clarinet instalado.

Una billetera compatible con Stacks (Leather o Xverse).

Instalación y Prueba
Clona el repositorio.

Ejecuta el check de seguridad:

Bash

clarinet check
Prueba el contrato en la consola interactiva:

Bash

clarinet console
🔗 Integración con AppKit (Reown)
Este contrato está preparado para ser consumido por un frontend moderno. Gracias a los mapas de usuario, puedes personalizar la interfaz:

Si is-vip es true: Desbloquea contenido exclusivo o temas visuales "premium" en tu dApp.

Contador de Tips: Muestra al usuario cuánto ha apoyado al proyecto en tiempo real consultando get-user-info.

🛡️ Seguridad
Autorización: Solo el dueño original puede pausar el contrato.

Validación de Montos: Se bloquean transferencias de 0 STX para evitar spam en el historial.

Clarity 2.0: Utiliza las últimas mejoras de seguridad del lenguaje para prevenir ataques de reentrada.
