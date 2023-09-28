import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

Window {
    id: window
    width: 480
    height: 480
    visible: true
    title: qsTr("Simple and cheap VU (that's the target :)")

    Label {
        id: label
        anchors.top: parent.top
        text: slider.actual
    }

    readonly property real nominal: 100
    readonly property real maxFactor: 1.25

    Slider {
        anchors.top: label.bottom
        id: slider
        width: window.width * 0.25
        height: 100
        orientation: Qt.Horizontal
        readonly property real actual: value * nominal * maxFactor
    }


    Rectangle {
        height:200
        width: 20
        anchors.top: slider.bottom

        id: vu
        property real actual: slider.actual
        property real nominal: window.nominal
        property real overshootFactor: window.maxFactor

        OpacityMask {
            anchors.fill: parent
            source: parent
            maskSource: parent
        }
        Rectangle { // top yellow red
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * (1 - 1 / vu.overshootFactor)
            gradient: Gradient {
                GradientStop { position: 0; color: "red" }
                GradientStop { position: 0.5; color: "orange" }
                GradientStop { position: 1.0; color: "green" }
            }
        }
        Rectangle {
            color: "green"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 1 / vu.overshootFactor
        }

        Rectangle {
            id: topRect
            color: "grey"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * (1 - vu.actual / (vu.overshootFactor * vu.nominal))

        }
    }

}
