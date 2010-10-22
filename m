Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55658 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0JVPnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:43:50 -0400
Received: by ewy7 with SMTP id 7so1270430ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 08:43:49 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/5] b43: define known SPROM boardflags2 bits
Date: Fri, 22 Oct 2010 17:43:47 +0200
Message-Id: <1287762229-16516-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
References: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 72821c4..9aad2ca 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -153,6 +153,19 @@
 #define B43_BFH_FEM_BT			0x0040	/* has FEM and switch to share antenna
 						 * with bluetooth */
 
+/* SPROM boardflags2_lo values */
+#define B43_BFL2_RXBB_INT_REG_DIS	0x0001	/* external RX BB regulator present */
+#define B43_BFL2_APLL_WAR		0x0002	/* alternative A-band PLL settings implemented */
+#define B43_BFL2_TXPWRCTRL_EN 		0x0004	/* permits enabling TX Power Control */
+#define B43_BFL2_2X4_DIV		0x0008	/* 2x4 diversity switch */
+#define B43_BFL2_5G_PWRGAIN		0x0010	/* supports 5G band power gain */
+#define B43_BFL2_PCIEWAR_OVR		0x0020	/* overrides ASPM and Clkreq settings */
+#define B43_BFL2_CAESERS_BRD		0x0040	/* is Caesers board (unused) */
+#define B43_BFL2_BTC3WIRE		0x0080	/* used 3-wire bluetooth coexist */
+#define B43_BFL2_SKWRKFEM_BRD		0x0100	/* 4321mcm93 uses Skyworks FEM */
+#define B43_BFL2_SPUR_WAR		0x0200	/* has a workaround for clock-harmonic spurs */
+#define B43_BFL2_GPLL_WAR		0x0400	/* altenative G-band PLL settings implemented */
+
 /* GPIO register offset, in both ChipCommon and PCI core. */
 #define B43_GPIO_CONTROL		0x6c
 
-- 
1.7.1

