Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:40114 "EHLO eggs.gnu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbbF3AZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 20:25:57 -0400
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
	(envelope-from <nikolas@gnu.org>)
	id 1Z9jMy-0004Qz-4v
	for linux-wireless@vger.kernel.org; Mon, 29 Jun 2015 20:25:56 -0400
From: Nik Nyby <nikolas@gnu.org>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, trivial@kernel.org
Cc: Nik Nyby <nikolas@gnu.org>
Subject: [PATCH] rtlwifi: Trivial: fix typo in comments
Date: Mon, 29 Jun 2015 20:17:55 -0400
Message-Id: <1435623475-20006-1-git-send-email-nikolas@gnu.org> (sfid-20150630_022601_767507_AEBE2ACF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a typo in two comments: "paht" -> "path".

Signed-off-by: Nik Nyby <nikolas@gnu.org>
---
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
index 1961b8e..bb06fe8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -3515,14 +3515,14 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 	for (rfpath = RF90_PATH_A; rfpath < rtlphy->num_total_rfpath;
 	     rfpath++) {
 		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
-			/* MOD_AG for RF paht_A 0x18 BIT8,BIT16 */
+			/* MOD_AG for RF path_A 0x18 BIT8,BIT16 */
 			rtl_set_rfreg(hw, rfpath, RF_CHNLBW, BIT(8) | BIT(16) |
 				      BIT(18), 0);
 			/* RF0x0b[16:14] =3b'111 */
 			rtl_set_rfreg(hw, (enum radio_path)rfpath, 0x0B,
 				      0x1c000, 0x07);
 		} else {
-			/* MOD_AG for RF paht_A 0x18 BIT8,BIT16 */
+			/* MOD_AG for RF path_A 0x18 BIT8,BIT16 */
 			rtl_set_rfreg(hw, rfpath, RF_CHNLBW, BIT(8) |
 				      BIT(16) | BIT(18),
 				      (BIT(16) | BIT(8)) >> 8);
-- 
2.1.4

