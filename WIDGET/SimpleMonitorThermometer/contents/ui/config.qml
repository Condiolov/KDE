import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick 2.0
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kquickcontrols 2.0 as KQControls
import QtQuick.Controls 2.5 as QQC2

Kirigami.FormLayout {
	property alias cfg_comando: comando.text
	property alias cfg_tempo: tempo.value
	property alias cfg_range: range.value
	property alias cfg_show_icon: show_icon.checked

	ColumnLayout {
		Layout.fillWidth: true
		ColumnLayout {
			RowLayout {
				Text {
					color:"#fff"; text: i18n("UPDATE (seconds)"); font.bold: true
				}
			}
			RowLayout {
				SpinBox {
					id: tempo; from:1; to: 300; stepSize: 1; editable: true; value: cfg_tempoDefault; Layout.fillWidth: true
				}
			}
		}
		ColumnLayout {
			RowLayout {
				Text {
					color:"#fff"; text: i18n("RANGE (default 0-100)"); font.bold: true
				}
			}

			RowLayout {
				SpinBox {
					id: range; from:1; to: 100000; stepSize: 1; editable: true; value: cfg_range; Layout.fillWidth: true
				}
			}
		}
		ColumnLayout {
			RowLayout {
				Text {
					text: i18n("COMMAND"); color: "#fff"; font.bold: true
				}
			}

			RowLayout {
				TextField {
					id: comando; placeholderText: i18n("just whole numbers*"); text: cfg_comandoDefault; Layout.fillWidth: true
				}
			}
		}

		RowLayout {
			QQC2.CheckBox {
				id: show_icon; text: "Hide icon and label"; checked: cfg_show_icon; onClicked: cfg_show_icon.checked = !cfg_show_icon.checked
			}
		}


		RowLayout {
			Text {
				text: i18n("EXAMPLES")
				color:"#fff"
				font.bold: true
			}
		}

		RowLayout {
			Text {
				text: i18n("GPU")
				color:"#ff0000"
				font.bold: true
			}
		}
		TextArea {
			text:"nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits"
			Layout.fillWidth: true
			wrapMode: Text.WordWrap
			background: Rectangle { color: "transparent"; border.width: 0 }
		}

		RowLayout {
			Text {
				text: i18n("CPU")
				color:"#ff0000"
				font.bold: true
			}
		}
		TextArea {
			text:"sensors | grep 'Tctl' | awk '{print int($2)}'"
			Layout.fillWidth: true
			wrapMode: Text.WordWrap
			background: Rectangle { color: "transparent"; border.width: 0 }
		}

		RowLayout {
			Text {
				text: i18n("TEMPERATURE IN 'JUIZ DE FORA-MG BRASIL' (latitude=-21.7684&longitude=-43.3504)")
				color:"#ff0000"
				font.bold: true
			}
		}
		TextArea {
			text:"curl -s \"https://api.open-meteo.com/v1/forecast?latitude=-21.7684&longitude=-43.3504&current_weather=true\" | jq '.current_weather.temperature'"
			Layout.fillWidth: true
			wrapMode: Text.WordWrap
			background: Rectangle { color: "transparent"; border.width: 0 }
		}

	}
}
