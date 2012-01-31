Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41000 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2AaPnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 10:43:16 -0500
Received: by vcge1 with SMTP id e1so116937vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 07:43:15 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Masanari Iida <standby24x7@gmail.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: Fix typo in dm.c
Date: Tue, 31 Jan 2012 09:42:58 -0600
Message-Id: <1328024578-7594-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120131_164324_580900_58828380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Masanari Iida <standby24x7@gmail.com>

Correct a spelling "disconnet" to "disconnect" in
drivers/net/wireless/rtlwifi/rtl8192de/dm.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index 181ed6f..9fda1af 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -294,7 +294,7 @@ static void rtl92d_dm_find_minimum_rssi(struct ieee80211_hw *hw)
 		de_digtable.min_undecorated_pwdb_for_dm =
 		    rtlpriv->dm.UNDEC_SM_PWDB;
 		RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
-			 "AP Ext Port or disconnet PWDB = 0x%x\n",
+			 "AP Ext Port or disconnect PWDB = 0x%x\n",
 			 de_digtable.min_undecorated_pwdb_for_dm);
 	}
 
-- 
1.7.7

