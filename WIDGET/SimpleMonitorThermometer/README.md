# Como Compilar um Plasmoid no KDE

Este guia explica como empacotar e compilar um Plasmoid no KDE.

## 📌 Requisitos
Certifique-se de ter os seguintes pacotes instalados:
- KDE Plasma
- `plasma-framework`
- `zip`

## 📂 Estrutura do Plasmoid
Seu plasmoid deve ter a seguinte estrutura:
```
SimpleMonitorThermometer/
├── metadata.json
├── contents/
│   ├── ui/
│   │   ├── main.qml
│   ├── config/
│   │   ├── Config.qml
```

## 🚀 Como Compilar o Plasmoid
Para empacotar seu Plasmoid, execute o seguinte comando no terminal:
```sh
zip -r SimpleMonitorThermometer.plasmoid metadata.json contents/
```
Isso criará um arquivo `SimpleMonitorThermometer.plasmoid`, que pode ser instalado no KDE.

## ✅ Testando o Plasmoid
Arraste o widget para à área de trabalho do KDE:
1. Clique em instalar

Agora seu Plasmoid está pronto para uso! 🎉

