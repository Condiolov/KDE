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
	property int range: plasmoid.configuration.range
	property string comandoUSER: plasmoid.configuration.comando
	Plasmoid.backgroundHints:PlasmaCore.Types.NoBackground

	property bool show_icon: plasmoid.configuration.show_icon
	Layout.preferredWidth: show_icon ? retangulo.width : icon.implicitWidth
	anchors.fill: show_icon ? undefined : parent
	property int value

// 	Text {
// 		id: labels
// 		text: ""
// 		color:"#fff"
// 		font.pixelSize:Math.max(icon.height, icon.width)*.2
// 		anchors.right: icon.right
// 	}
//
//
//
// 	Kirigami.Icon {
// 		id: icon
// 		height: Math.min(parent.height, parent.width)
// 		width: valid ? height : 0
// 		source: Qt.resolvedUrl("./svg/temp1.svg")
// 	}

Text {
	visible: show_icon ? false : true
	id: labels
	text: root.value
	color:"#fff"
	font.pixelSize:Math.max(icon.height, icon.width)*.2
	anchors.right: icon.right
	anchors.rightMargin: labels.width/2
	anchors.top: icon.top
}
Rectangle {
	// ToolTip.text: "Esta é uma dica de ferramenta!"
	// ToolTip.visible: hovered
	id: retangulo
	width: !show_icon ? 4 * icon.width/22 : 7

	// height: !show_icon ? root.value * icon.height/110 :  root.value * root.height/100
	height: !show_icon ? root.value / range * 100 * icon.height/110 :  root.value / range * 100 * root.height/100
	color: getColor(root.value)
	radius: icon.height * .3 // Bordas arredondadas
	anchors.horizontalCenter: !show_icon ? icon.horizontalCenter : root.horizontalCenter
	// anchors.verticalCenter: parent.verticalCenter
	anchors.bottom: !show_icon ? icon.bottom : root.bottom
	anchors.bottomMargin: !show_icon ? icon.height * (3 / 22) : 0
}
Kirigami.Icon {
	anchors.verticalCenter: parent.verticalCenter
	// Layout.alignment: Qt.AlignCenter
	visible: show_icon ? false : true
	id: icon
	height: Math.min(root.height, root.width)
	width: Math.min(root.height, root.width)
	source: Qt.resolvedUrl("./svg/temp0.svg")
	color: "red"

}
	fullRepresentation: Item {
		id: container
	}

	compactRepresentation: MouseArea {
		anchors.fill: parent
		onClicked: executable.exec(comandoUSER)
		onDoubleClicked: Plasmoid.internalAction("configure").trigger()
	}




	// Exemplo de como atualizar o tooltip dinamicamente

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
	function getColor(value) {

		value= value / range * 100
		let red = 0, green = 0;

		if (value < 30) {
			// Verde puro
			red = 0;
			green = 255;
		} else if (value >= 30 && value < 50) {
			// Transição de Verde para Amarelo (aumenta o vermelho)
			red = Math.min(255, (value - 30) * 12.75); // 0 → 255
			green = 255;
		} else if (value >= 50 && value < 60) {
			// Transição de Amarelo para Laranja (diminui o verde para 165)
			red = 255;
			green = Math.max(165, 255 - (value - 50) * 9);
		} else if (value >= 60 && value < 70) {
			// Transição de Laranja para Vermelho (diminui o verde para 0)
			red = 255;
			green = Math.max(0, 165 - (value - 60) * 16.5);
		} else {
			// Vermelho puro
			red = 255;
			green = 0;
		}

		return Qt.rgba(red / 255, green / 255, 0, 1);
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
			// console.log("Saída: " + out)
			// console.log("Erro: " + err)
			// console.log("Código de saída: " + code)

			if (code === 0) {

				root.value = parseInt(out)  // Exibe a saída do print do Python no Label

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
