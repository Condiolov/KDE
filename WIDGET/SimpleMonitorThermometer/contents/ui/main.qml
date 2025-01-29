import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami as Kirigami
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
	id: root
	property int tempoAtualizacao: plasmoid.configuration.tempo
	property string comandoUSER: plasmoid.configuration.comando
	Plasmoid.backgroundHints:PlasmaCore.Types.NoBackground

	Text {
		id: labels
		text: ""
		color:"#fff"
		font.pixelSize:Math.max(icon.height, icon.width)*.2
		anchors.right: icon.right
	}

	Kirigami.Icon {
		id: icon
		height: Math.min(parent.height, parent.width)
		width: valid ? height : 0
		source: Qt.resolvedUrl("./svg/temp1.svg")
	}

	fullRepresentation: Item {
		id: container
	}

	compactRepresentation: MouseArea {
		anchors.fill: parent
		onClicked: executable.exec(comandoUSER)
		onDoubleClicked: Plasmoid.internalAction("configure").trigger()
	}

	MouseArea {
		anchors.fill: parent
		onClicked: executable.exec(comandoUSER)
		onDoubleClicked: Plasmoid.internalAction("configure").trigger()
	}

	Timer {
		id: updateTimer
		interval: root.tempoAtualizacao * 1000  // Tempo de atualização em milissegundos
		running: true
		repeat: true
		onTriggered: {
			executable.exec(comandoUSER)
		}
	}
	Plasma5Support.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: function(source, data) {
			var cmd = source
			var out = data["stdout"].replace(/\u001b\[[0-9;]*[m|K]/g, '')  // Limpa códigos de controle ANSI
			var err = data["stderr"]
			var code = data["exit code"]

			// console.log("Comando executado: " + cmd)
			console.log("Saída: " + out)
			// console.log("Erro: " + err)
			// console.log("Código de saída: " + code)

			if (code === 0) {
				labels.text = out  // Exibe a saída do print do Python no Label

				if (out >= 70)
				icon.source= Qt.resolvedUrl("./svg/temp5.svg")
				else if (out >= 60)
				icon.source= Qt.resolvedUrl("./svg/temp4.svg")
				else if (out >= 50)
				icon.source= Qt.resolvedUrl("./svg/temp3.svg")
				else if (out >= 40)
				icon.source= Qt.resolvedUrl("./svg/temp2.svg")
				else if (out < 40)
				icon.source= Qt.resolvedUrl("./svg/temp1.svg")

			} else {
				labels.text = "Erro: " + err  // Exibe o erro se ocorrer
				updateTimer.running = false;
			}
			disconnectSource(source)
		}

		function exec(cmd) {
			executable.connectSource(cmd)
		}
	}
	Connections {
		target: root  // Ou outro objeto onde a propriedade é declarada
		function onComandoUSERChanged() {
			executable.exec(comandoUSER)
			updateTimer.running = true;
		}
	}

	Component.onCompleted: {
		executable.exec(comandoUSER)
	}

}
