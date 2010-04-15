Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab0DODa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 97/97] ath9k_hw: add the PCI ID for the first AR9300 device
Date: Wed, 14 Apr 2010 23:30:51 -0400
Message-Id: <1271302251-9075-98-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first AR9003 hardware family device supported is the
AR9300, which has the vendor:device id 168c:0030

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 1ec836c..257b10b 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -28,6 +28,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x002C) }, /* PCI-E 802.11n bonded out */
 	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
+	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
 	{ 0 }
 };
 
-- 
1.6.3.3

