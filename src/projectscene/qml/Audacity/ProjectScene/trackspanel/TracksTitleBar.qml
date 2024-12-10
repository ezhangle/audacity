import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Muse.Ui
import Muse.UiComponents

import "qrc:/kddockwidgets/private/quick/qml/" as KDDW

KDDW.TitleBarBase {
    id: root

    property var navigationPanel
    property var navigationOrder
    property var contextMenuModel

    property int effectsSectionWidth: 0
    property bool showEffectsSection: false
 
    signal effectsSectionCloseButtonClicked()

    property int expectedHeight: 39

    signal addRequested(type: int)

    anchors.fill: parent
    implicitHeight: gripButton.implicitHeight
    heightWhenVisible: expectedHeight

    Component.onCompleted: {
        if (effectsSectionWidth == 0) {
            console.warn("effectsSectionWidth is not set ; doing some guesswork")
            effectsSectionWidth = 240
        }
    }

    onShowEffectsSectionChanged: {
        rowLayout.effectsTitleBar.visible = showEffectsSection
    }

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 0

        property alias effectsTitleBar: effectsTitleBar

        Rectangle {
            id: effectsTitleBar
            visible: false
            color: ui.theme.backgroundPrimaryColor
            property int padding: parent.height / 4
            border.color: "transparent"
            border.width: padding

            Layout.preferredWidth: root.effectsSectionWidth
            Layout.preferredHeight: root.expectedHeight

            StyledTextLabel {
                text: qsTr("Effects")
                anchors.fill: parent
                padding: effectsTitleBar.padding
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
            }

            Rectangle {
                color: effectsTitleBar.color
                width: root.expectedHeight
                height: root.expectedHeight
                anchors.right: parent.right
                FlatButton {
                    transparent: true
                    width: parent.width - 2 * effectsTitleBar.padding
                    height: parent.height - 2 * effectsTitleBar.padding
                    anchors.centerIn: parent
                    normalColor: ui.theme.backgroundPrimaryColor
                    hoverHitColor: ui.theme.buttonColor
                    icon: IconCode.CLOSE_X_ROUNDED
                    onClicked: {
                        root.effectsSectionCloseButtonClicked()
                    }
                }
            }
        }

        FlatButton {
            id: gripButton

            Layout.preferredHeight: root.expectedHeight
            Layout.preferredWidth: 28
            backgroundRadius: 0

            visible: true
            normalColor: ui.theme.backgroundSecondaryColor
            hoverHitColor: ui.theme.buttonColor

            mouseArea.objectName: root.objectName + "_gripButton"
            mouseArea.cursorShape: Qt.SizeAllCursor
            // do not accept buttons as FlatButton's mouseArea will override
            // DockTitleBar mouseArea and panel will not be draggable
            mouseArea.acceptedButtons: Qt.NoButton

            transparent: false
            contentItem: StyledIconLabel {
                iconCode: IconCode.TOOLBAR_GRIP
            }

            backgroundItem: TracksTitleBarBackground {
                mouseArea: gripButton.mouseArea
                color: gripButton.normalColor
                baseColor: gripButton.normalColor
            }
        }

        SeparatorLine { }

        FlatButton {
            id: addNewTrackBtn

            width: root.verticalPanelDefaultWidth - gripButton.width
            Layout.fillWidth: true
            Layout.preferredHeight: root.expectedHeight

            accessible.name: qsTrc("projectscene", "Add Track")
            backgroundRadius: 0
            normalColor: ui.theme.backgroundSecondaryColor
            hoverHitColor: ui.theme.buttonColor

            text: qsTrc("projectscene", "Add new track")

            //! TODO AU4
            enabled: true //root.isAddingAvailable

            icon: IconCode.PLUS

            orientation: Qt.Horizontal

            backgroundItem: TracksTitleBarBackground {
                mouseArea: addNewTrackBtn.mouseArea
                color: addNewTrackBtn.normalColor
                baseColor: addNewTrackBtn.normalColor
            }

            onClicked: {
                if (addNewTrack.isOpened) {
                    addNewTrack.close()
                } else {
                    addNewTrack.open()
                }
            }

            AddNewTrackPopup {
                id: addNewTrack

                onCreateTrack: (type) => {
                    root.addRequested(type)
                }
            }
        }
    }

    SeparatorLine {
        anchors.top: rowLayout.bottom
    }
}