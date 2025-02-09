import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick 2.0
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kquickcontrols 2.0 as KQControls

Kirigami.FormLayout {
    // KCM.SimpleKCM {
    property alias cfg_moedas: moedas.text
    property alias cfg_tempo: tempo.value
    property alias cfg_cor1: cor1.color
    property alias cfg_cor2: cor2.color
    property alias cfg_cor3: cor3.color
    property alias cfg_cor4: cor4.color
    property alias cfg_fundo: fundo.color

    Kirigami.FormLayout {
        ColumnLayout {
            RowLayout {
                ColumnLayout {
                    RowLayout {
                        Text {
                            text: i18n("CRYPTOS")
                            color:"#fff"
                            font.bold: true
                        }
                    }
                    TextField {
                        id: moedas
                        placeholderText: i18n("Digite as moedas separadas por vírgula (ex: ETHUSDT,DOGEUSDT)")
                        text: cfg_moedas
                        Kirigami.FormData.label: i18n("Moedas:")
                        Layout.fillWidth: true
                            }
                }
                ColumnLayout {

                    RowLayout {
                        Text {
                            color:"#fff"
                            text: i18n("UPDATE")
                            font.bold: true
                        }
                    }

                    SpinBox {
                        id: tempo
                        from: 1
                        to: 3600
                        value: cfg_tempo
                        stepSize: 1
                        Kirigami.FormData.label: i18n("Tempo de Atualização (em segundos):")
                        Layout.fillWidth: true
                    }
                }
            }

            Rectangle {
                // id: space
                Layout.fillWidth: true
                height: 20
                color: "transparent"
            }

            RowLayout {
                // spacing: 1
                anchors.centerIn: parent
                Rectangle {
                    id: retagulo
                    color: fundo.color
                    width: dynamicLabel1.width + 20
                    height: dynamicLabel1.height + 20
                    radius: 10

                    Item {
                        id: textos
                        anchors.fill: parent
                        anchors.margins: 10

                        Text {
                            id: dynamicLabel1
                            text: "<b><font color='" + cor1.color + "' size='7'>A$ <font color='" +
                            cor2.color + "'> 1000.0000</font></b> <i><font family='Arial' color='" +
                            cor4.color + "' pixelSize='12'> 1.0%</font></i><br><b><font color='" +
                            cor1.color + "' size='7'>B$ <font color='" +
                            cor3.color + "'> 1000.0000</font></b> <i><font family='Arial' color='" +
                            cor4.color + "' pixelSize='12'>-1.0%</font></i><br>";
                        }
                    }
                }
            }

            Rectangle {
                id: space
                Layout.fillWidth: true
                height: 20
                color: "transparent"
            }

            RowLayout {
                anchors.centerIn: space // Centraliza o RowLayout das cores
                KQControls.ColorButton {
                    id: fundo
                    showAlphaChannel: true
                }
                KQControls.ColorButton {
                    id: cor1
                    showAlphaChannel: true
                }
                KQControls.ColorButton {
                    id: cor2
                    showAlphaChannel: true
                }
                KQControls.ColorButton {
                    id: cor3
                    showAlphaChannel: true
                }
                KQControls.ColorButton {
                    id: cor4
                    showAlphaChannel: true
                }
            }
        }
    }
}
