Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:56105 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2ECFLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:11:20 -0400
Message-ID: <4FA21375.7090203@gtri.gatech.edu> (sfid-20120503_071122_292912_37ACC6A1)
Date: Thu, 3 May 2012 01:11:17 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/9] rtlwifi: fix typo
References: <4FA212D9.5020602@gtri.gatech.edu>
In-Reply-To: <4FA212D9.5020602@gtri.gatech.edu>
Content-Type: multipart/mixed;
	boundary="------------020001000005030303080900"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------020001000005030303080900
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit



--------------020001000005030303080900
Content-Type: text/x-patch; name="0003-rtlwifi-fix-typo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="0003-rtlwifi-fix-typo.patch"

>From c5b3148ba19f9292030709cfd6476bc3db9bf077 Mon Sep 17 00:00:00 2001
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Date: Thu, 3 May 2012 00:07:45 -0400
Subject: [PATCH 3/9] rtlwifi: fix typo


Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
index d1b0a1e..4373f43 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
@@ -346,7 +346,7 @@ do {								\
 #define SET_RX_STATUS_DESC_BC(__pdesc, __val)			\
 	SET_BITS_OFFSET_LE(__pdesc + 4, 31, 1, __val)
 
-#define GET_RX_STATUS_DEC_MACID(__pdesc)			\
+#define GET_RX_STATUS_DESC_MACID(__pdesc)			\
 	SHIFT_AND_MASK_LE(__pdesc + 4, 0, 5)
 #define GET_RX_STATUS_DESC_TID(__pdesc)				\
 	SHIFT_AND_MASK_LE(__pdesc + 4, 5, 4)
-- 
1.7.7.6


--------------020001000005030303080900--
