Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57504 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2DGV1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2012 17:27:33 -0400
Received: by obbtb18 with SMTP id tb18so4422399obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Apr 2012 14:27:32 -0700 (PDT)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2x00: remove ssid_context struct
Date: Sat,  7 Apr 2012 17:31:21 -0400
Message-Id: <1333834281-23502-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120407_232810_059707_E6F6A1B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver does not use it any more.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.h b/drivers/net/wireless/ipw2x00/ipw2100.h
index 99cba96..18741a4 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/ipw2x00/ipw2100.h
@@ -135,15 +135,6 @@ enum {
 	IPW_HW_STATE_ENABLED = 0
 };
 
-struct ssid_context {
-	char ssid[IW_ESSID_MAX_SIZE + 1];
-	int ssid_len;
-	unsigned char bssid[ETH_ALEN];
-	int port_type;
-	int channel;
-
-};
-
 extern const char *port_type_str[];
 extern const char *band_str[];
 
-- 
1.7.2.5

