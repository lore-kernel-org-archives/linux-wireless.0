Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3201 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758112AbYDBQDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 12:03:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ipw3945-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] drivers/net/wireless/iwlwifi/iwl-3945.h: correct CONFIG_IWL4965_LEDS typo
Date: Wed,  2 Apr 2008 11:35:32 -0400
Message-Id: <1207150532-30440-1-git-send-email-linville@tuxdriver.com> (sfid-20080402_170411_294504_E38409FD)
In-Reply-To: <47F38D53.3020901@tilanus.com>
References: <47F38D53.3020901@tilanus.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thakns to Winfried Tilanus <winfried@tilanus.com> for identifying the
problem!

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index ac12269..8114d05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -779,7 +779,7 @@ struct iwl3945_priv {
 	struct iwl3945_init_alive_resp card_alive_init;
 	struct iwl3945_alive_resp card_alive;
 
-#ifdef CONFIG_IWL4965_LEDS
+#ifdef CONFIG_IWL3945_LEDS
 	struct iwl3945_led led[IWL_LED_TRG_MAX];
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
-- 
1.5.3.3

