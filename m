Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:43432 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752212Ab1DAR4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 13:56:31 -0400
Received: by mail-ey0-f182.google.com with SMTP id 7so1526730eyg.41
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 10:56:29 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: remove unused conf_radio_params structure
Date: Fri,  1 Apr 2011 20:56:56 +0300
Message-Id: <1301680616-7940-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This structure has not been used anymore since commit
e6b190ff3c2f4e4859502c41fa17b5c595e82000.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/conf.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 52269d4..6c9e3a6 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1020,15 +1020,6 @@ enum single_dual_band_enum {
 #define CONF_NUMBER_OF_CHANNELS_2_4 14
 #define CONF_NUMBER_OF_CHANNELS_5   35
 
-struct conf_radio_parms {
-	/*
-	 * FEM parameter set to use
-	 *
-	 * Range: 0 or 1
-	 */
-	u8 fem;
-};
-
 struct conf_itrim_settings {
 	/* enable dco itrim */
 	u8 enable;
-- 
1.7.1

