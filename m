Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1494 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab1L1A7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 19:59:51 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: John W Linville <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 6/7] rt2x00: RT3593 is also applicable to USB.
Date: Wed, 28 Dec 2011 01:53:23 +0100
Message-Id: <1325033604-26469-7-git-send-email-gwingerde@gmail.com> (sfid-20111228_020001_456838_F672BE65)
In-Reply-To: <1325033604-26469-6-git-send-email-gwingerde@gmail.com>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-2-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-3-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-4-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-5-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-6-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 851b717..b03b22c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -189,7 +189,7 @@ struct rt2x00_chip {
 #define RT3090		0x3090	/* 2.4GHz PCIe */
 #define RT3390		0x3390
 #define RT3572		0x3572
-#define RT3593		0x3593	/* PCIe */
+#define RT3593		0x3593
 #define RT3883		0x3883	/* WSOC */
 #define RT5390		0x5390  /* 2.4GHz */
 
-- 
1.7.7.4

