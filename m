Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56846 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1FMNl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 09:41:59 -0400
Received: by fxm17 with SMTP id 17so2670499fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 06:41:58 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: define new PHYs and radio regs for cores >= 24
Date: Mon, 13 Jun 2011 16:20:05 +0200
Message-Id: <1307974806-25902-1-git-send-email-zajec5@gmail.com> (sfid-20110613_154203_021714_4A60A7D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 8d4bb28..f3efa42 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -92,6 +92,8 @@
 #define B43_MMIO_PIO11_BASE4		0x300
 #define B43_MMIO_PIO11_BASE5		0x340
 
+#define B43_MMIO_RADIO24_CONTROL	0x3D8	/* core rev >= 24 only */
+#define B43_MMIO_RADIO24_DATA		0x3DA	/* core rev >= 24 only */
 #define B43_MMIO_PHY_VER		0x3E0
 #define B43_MMIO_PHY_RADIO		0x3E2
 #define B43_MMIO_PHY0			0x3E6
@@ -363,6 +365,10 @@ enum {
 #define B43_PHYTYPE_G			0x02
 #define B43_PHYTYPE_N			0x04
 #define B43_PHYTYPE_LP			0x05
+#define B43_PHYTYPE_SSLPN		0x06
+#define B43_PHYTYPE_HT			0x07
+#define B43_PHYTYPE_LCN			0x08
+#define B43_PHYTYPE_LCNXN		0x09
 
 /* PHYRegisters */
 #define B43_PHY_ILT_A_CTRL		0x0072
-- 
1.7.3.4

