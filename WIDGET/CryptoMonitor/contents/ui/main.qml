import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami as Kirigami
import QtQuick.Layouts 1.15

PlasmoidItem {
	id: root
	property string moedas: plasmoid.configuration.moedas
	property int tempoAtualizacao: plasmoid.configuration.tempo
	property color cor1: plasmoid.configuration.cor1
	property color cor2: plasmoid.configuration.cor2
	property color cor3: plasmoid.configuration.cor3
	property color cor4: plasmoid.configuration.cor4
	property color fundo: plasmoid.configuration.fundo
	property string label //: plasmoid.configuration.label
	property bool carregando: false
	property bool inicializacaoConcluida: false
	property int qnt_moeda : moedas.split(",").length
	Plasmoid.backgroundHints:PlasmaCore.Types.NoBackground
	// property string apiUrl: "https://production.api.coindesk.com/v2/tb/price/ticker?assets=" + moedas
	property string apiUrl: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + moedas + "&tsyms=USD"
	property var precos: []
	property int margem: 30
	property int compacto: 0

	fullRepresentation: Item {
		id: container
		Layout.minimumWidth: compacto === 1 ? labels.implicitWidth + margem : 0
		Layout.minimumHeight:  0

		Rectangle {
			id: retangulo
			color: root.carregando ? "transparent" : fundo
			width: labels.width + margem
			height: labels.height+ margem
			radius: 10 // Define o grau de arredondamento das bordas
			MouseArea {
				anchors.fill: parent
				onClicked: fetchPrices()
				onDoubleClicked: Plasmoid.internalAction("configure").trigger()
			}
		}

		Item {
			id: textos
			anchors.fill: parent
			anchors.margins: margem/2
			opacity: root.carregando ? 0.3 : 1
			Text {
				id: labels
				text: label
				wrapMode: Text.WordWrap
				font.pixelSize: compacto === 1 ?   Math.min(10, Math.max(4, parent.height * 0.3 / qnt_moeda))  : Math.max(parent.height, parent.width) * Math.sqrt(qnt_moeda) / (2*qnt_moeda)
			}
		}

		Kirigami.Icon{
			id: loadingIcon
			source: "view-refresh"
			width: 64
			height: 64
			anchors.centerIn: retangulo
			visible: root.carregando
			// anchors.verticalCenter: parent.verticalCenter
			// anchors.horizontalCenter: parent.horizontalCenter
			RotationAnimator {
				id: rotationAnimator
				target: loadingIcon // Define o alvo da animação
				from: 0 // Ângulo inicial
				to: 360 // Ângulo final
				duration: 1000 // Duração da animação em milissegundos (1 segundo)
				loops: Animation.Infinite // Repete infinitamente
				running: root.carregando
			}
		}
	}

	compactRepresentation: MouseArea {
		// onClicked: root.expanded = !root.expanded

		PlasmaComponents.ToolButton {
			anchors.fill: parent
			icon.name: "view-institution-symbolic"
			text: "Pin"
			display: PlasmaComponents.ToolButton.IconOnly
			onClicked: {
				// fetchPrices()
				root.expanded = !root.expanded
				// fundo = "transparent"
				compacto = 1
			}
		}
	}

	// Função para pegar os preços das criptomoedas
	function fetchPrices() {
		/*request.timeout = 5000; */// Define um timeout de 5 segundos para a requisição
		root.carregando = true
		var request = new XMLHttpRequest()
		request.open("GET", apiUrl, true)
		request.onreadystatechange = function() {
			if (request.readyState === XMLHttpRequest.DONE) {
				if (request.status === 200) {
					var jsonResponse = JSON.parse(request.responseText);
					// Dividir as moedas configuradas em um array
					var moedasArray = moedas.split(",");
					moedasArray.sort();
					root.precos = "";
					// Iterar sobre as moedas e pegar os preços correspondentes
					label = "";
					for (var moedaSymbol in jsonResponse.RAW) {
						if (moedasArray.indexOf(moedaSymbol) !== -1) {
							var moedaInfo = jsonResponse.RAW[moedaSymbol].USD;
							var currentPrice = moedaInfo.PRICE;
							var abertura = moedaInfo.OPEN24HOUR;
							var moedaPercent = moedaInfo.CHANGEPCT24HOUR;
							var moedaColor = moedaPercent > 0 ? cor2 : cor3;
							// console.log(moedaInfo +currentPrice)
							label += "<b><font color='" + cor1 + "' size='7'>" + moedaSymbol.substring(0, 1).toUpperCase() + "$ <font color='" + moedaColor + "'>" + currentPrice.toFixed(6) + "</font></b> <i><font family='Arial' color='" + cor4 + "' pixelSize='12'>" + moedaPercent.toFixed(2) + "%</font></i><br>";
							root.carregando = false
						}
					}
				} else {

					console.log(JSON.parse(request.responseText).message)
					// label.width= 200*2
					label = "<font family='Arial' color='" + cor4 + "' pixelSize='12'>" + JSON.parse(request.responseText).message + "</font>"
					updateTimer.running = false;
				}
			}


		}
		request.send()
	}
	MouseArea {
		anchors.fill: parent
		onClicked: fetchPrices(textField.text)
		onDoubleClicked: Plasmoid.internalAction("configure").trigger()
	}
	Shortcut {
		id: openShortcut
		sequences: ["Meta+B"] // Define o atalho (Super + B)
		onActivated: {
			root.expanded = !root.expanded
			fundo = "transparent"
			compacto =1
		}
	}
	// Timer para atualizar o preço com base no tempo fornecido
	Timer {
		id: updateTimer
		interval: root.tempoAtualizacao * 1000  // Tempo de atualização em milissegundos
		running: true
		repeat: true
		onTriggered: {
			fetchPrices()
		}
	}
	Timer {
		id: monitorarCarregamentoTimer
		interval: 5000 // 5 segundos
		running: false
		repeat: false
		onTriggered: {
			if (root.carregando) {
				console.log("Carregamento demorou mais de 5 segundos. Tentando novamente...");
				fetchPrices(); // Chama fetchPrices novamente
			}
		}
	}
	Connections {
		target: root  // Ou outro objeto onde a propriedade é declarada
		onMoedasChanged: updateTimer.running = true;
	}

	Component.onCompleted: {
		fetchPrices()
		monitorarCarregamentoTimer.start();
	}

}
