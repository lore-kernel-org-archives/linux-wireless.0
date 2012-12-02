Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40156 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab2LBQYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 11:24:06 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] rt2x00: rt2800lib: remove trailing semicolons from RFCSR3_* defines
Date: Sun,  2 Dec 2012 17:24:02 +0100
Message-Id: <1354465442-1028-1-git-send-email-juhosg@openwrt.org> (sfid-20121202_172414_846389_694CE87C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 6d67c3e..1157b06 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1993,8 +1993,8 @@ struct mac_iveiv_entry {
  */
 #define RFCSR3_K			FIELD8(0x0f)
 /* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
-#define RFCSR3_PA1_BIAS_CCK		FIELD8(0x70);
-#define RFCSR3_PA2_CASCODE_BIAS_CCKK	FIELD8(0x80);
+#define RFCSR3_PA1_BIAS_CCK		FIELD8(0x70)
+#define RFCSR3_PA2_CASCODE_BIAS_CCKK	FIELD8(0x80)
 
 /*
  * FRCSR 5:
-- 
1.7.10

