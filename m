Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:54819 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2EHCS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 22:18:57 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/9] rtlwifi: fix typo
Date: Mon, 7 May 2012 22:18:34 -0400
Message-ID: <1336443521-15299-3-git-send-email-Joshua.Roys@gtri.gatech.edu> (sfid-20120508_041901_317037_2EE91BC4)
In-Reply-To: <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
References: <4FA212D9.5020602@gtri.gatech.edu>
 <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
index 20afec6..0418b7c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
@@ -341,7 +341,7 @@
 #define SET_RX_STATUS_DESC_BC(__pdesc, __val)			\
 	SET_BITS_OFFSET_LE(__pdesc + 4, 31, 1, __val)
 
-#define GET_RX_STATUS_DEC_MACID(__pdesc)			\
+#define GET_RX_STATUS_DESC_MACID(__pdesc)			\
 	SHIFT_AND_MASK_LE(__pdesc + 4, 0, 5)
 #define GET_RX_STATUS_DESC_TID(__pdesc)				\
 	SHIFT_AND_MASK_LE(__pdesc + 4, 5, 4)
-- 
1.7.4.1

