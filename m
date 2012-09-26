Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:45071 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627Ab2IZD2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:28:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 01/15] mwifiex: fix coding style issue
Date: Tue, 25 Sep 2012 20:23:31 -0700
Message-Id: <1348629825-12001-2-git-send-email-bzhao@marvell.com> (sfid-20120926_052840_201571_4AD0E72C)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Remove unnecessary blank lines and extra tab.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ---
 drivers/net/wireless/mwifiex/wmm.c      |    2 +-
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c24824f..6fd4fa6 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -688,7 +688,6 @@ mwifiex_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /* Supported rates to be advertised to the cfg80211 */
-
 static struct ieee80211_rate mwifiex_rates[] = {
 	{.bitrate = 10, .hw_value = 2, },
 	{.bitrate = 20, .hw_value = 4, },
@@ -705,7 +704,6 @@ static struct ieee80211_rate mwifiex_rates[] = {
 };
 
 /* Channel definitions to be advertised to cfg80211 */
-
 static struct ieee80211_channel mwifiex_channels_2ghz[] = {
 	{.center_freq = 2412, .hw_value = 1, },
 	{.center_freq = 2417, .hw_value = 2, },
@@ -773,7 +771,6 @@ static struct ieee80211_supported_band mwifiex_band_5ghz = {
 
 
 /* Supported crypto cipher suits to be advertised to cfg80211 */
-
 static const u32 mwifiex_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_WEP40,
 	WLAN_CIPHER_SUITE_WEP104,
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 766d452..07a4540 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -462,7 +462,7 @@ mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 	for (i = 0; i < adapter->priv_num; ++i) {
 		priv = adapter->priv[i];
 		if (priv && atomic_read(&priv->wmm.tx_pkts_queued))
-				return false;
+			return false;
 	}
 
 	return true;
-- 
1.7.0.2

