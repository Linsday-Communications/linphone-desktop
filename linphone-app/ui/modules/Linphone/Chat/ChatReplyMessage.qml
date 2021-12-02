import QtQuick 2.7
import QtQuick.Layouts 1.3

import Clipboard 1.0
import Common 1.0
import Linphone 1.0

import Common.Styles 1.0
import Linphone.Styles 1.0
import TextToSpeech 1.0
import Utils 1.0
import Units 1.0
import UtilsCpp 1.0
import LinphoneEnums 1.0

import ColorsList 1.0

import 'Message.js' as Logic

// =============================================================================

Item {
	id: mainItem
	property ChatMessageModel chatMessageModel
	property ChatMessageModel mainChatMessageModel
	property int maxWidth : parent.width
	property int headerHeight: ChatReplyMessageStyle.header.replyIcon.iconSize
	property int replyHeight: (chatMessageModel ? replyMessage.implicitHeight + usernameReplied.implicitHeight + ChatStyle.entry.message.padding * 2 + 3 : 0)
	property int fitWidth: Math.max(usernameReplied.implicitWidth + replyMessage.implicitWidth , headerArea.fitWidth) + 7 + ChatReplyMessageStyle.padding * 2
	property int fitHeight: headerHeight + replyHeight
	
	property font customFont : SettingsModel.textMessageFont
	
	width: maxWidth < 0 || maxWidth > fitWidth ? fitWidth : maxWidth
	height: fitHeight
	onMainChatMessageModelChanged: if( mainChatMessageModel && mainChatMessageModel.replyChatMessageModel) chatMessageModel = mainChatMessageModel.replyChatMessageModel
	
	
	ColumnLayout{
		anchors.fill: parent
		spacing: 5
		Row{
			id: headerArea
			property int fitWidth: icon.width + headerText.implicitWidth
			Layout.preferredHeight: headerHeight
			Layout.topMargin: 5
			Icon{
				id: icon
				icon: ChatReplyMessageStyle.header.replyIcon.icon
				iconSize: ChatReplyMessageStyle.header.replyIcon.iconSize
				height: iconSize
				overwriteColor: ChatReplyMessageStyle.header.color
			}
			Text{
				id: headerText
				height: parent.height
				verticalAlignment: Qt.AlignVCenter
				//: 'Reply' : Header on a message that contains a reply.
				text: qsTr('headerReply')
							+ (chatMessageModel || !mainChatMessageModel? '' : ' - ' + mainChatMessageModel.fromDisplayNameReplyMessage)
				font.family: mainItem.customFont.family
				font.pointSize: Units.dp * (mainItem.customFont.pointSize + ChatReplyMessageStyle.header.pointSizeOffset)
				color: ChatReplyMessageStyle.header.color
			}
		}
		Rectangle{
			id: replyArea
			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.bottomMargin: ChatStyle.entry.message.padding
			Layout.leftMargin: 10
			Layout.rightMargin: 10
			Rectangle{
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				width: 7
				color: chatMessageModel && chatMessageModel.isOutgoing ? ChatReplyMessageStyle.replyArea.outgoingMarkColor  : ChatReplyMessageStyle.replyArea.incomingMarkColor
			}
			
			radius: 5
			color: ChatReplyMessageStyle.replyArea.backgroundColor
			visible: chatMessageModel != undefined
			Text{
				id: usernameReplied
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.topMargin: 3
				
				
				leftPadding: 2 * ChatStyle.entry.message.padding
				
				text: mainChatMessageModel && mainChatMessageModel.fromDisplayNameReplyMessage
				font.family: mainItem.customFont.family
				font.pointSize: Units.dp * (mainItem.customFont.pointSize + ChatReplyMessageStyle.replyArea.usernamePointSizeOffset)
				font.weight: Font.Bold
				
				color: ChatReplyMessageStyle.replyArea.foregroundColor
			}
			TextEdit {
				id: replyMessage
				property string lastTextSelected : ''
				property font customFont : SettingsModel.textMessageFont
				
				anchors.top: usernameReplied.bottom
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.topMargin: 3
				
				clip: true
				leftPadding: 2*ChatStyle.entry.message.padding
				rightPadding: ChatStyle.entry.message.padding
				bottomPadding: ChatStyle.entry.message.padding
				readOnly: true
				selectByMouse: true
				font.family: customFont.family
				font.pointSize: Units.dp * (customFont.pointSize + ChatReplyMessageStyle.replyArea.pointSizeOffset)
				font.weight: Font.Light
				color: ChatReplyMessageStyle.replyArea.foregroundColor
				text: (visible && chatMessageModel? Utils.encodeTextToQmlRichFormat(chatMessageModel.content, {
														  imagesHeight: ChatStyle.entry.message.images.height,
														  imagesWidth: ChatStyle.entry.message.images.width
													  }) 
								: '')
				
				textFormat: Text.RichText // To supports links and imgs.
				wrapMode: TextEdit.Wrap
			}
		}
	}
}