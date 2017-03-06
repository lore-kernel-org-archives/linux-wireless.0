Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16439 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbdCFMNU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 07:13:20 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH] mac80211_hwsim: Add channel 169 (5845 MHz)
Date: Mon, 6 Mar 2017 11:56:06 +0200
Message-ID: <1488794166-26903-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20170306_131341_617395_D3D5182B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This channel is defined in the IEEE 802.11 standard and available in
number of countries, so extend the mac80211_hwsim channel list to cover
channel 169 to enable additional testing.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7b9662a..8b823c7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -350,6 +350,7 @@ static const struct ieee80211_channel hwsim_channels_5ghz[] = {
 	CHAN5G(5785), /* Channel 157 */
 	CHAN5G(5805), /* Channel 161 */
 	CHAN5G(5825), /* Channel 165 */
+	CHAN5G(5845), /* Channel 169 */
 };
 
 static const struct ieee80211_rate hwsim_rates[] = {
-- 
2.7.4
