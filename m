Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59376 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab0LBLRR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:17:17 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:17:03 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 27/27] ath9k: Add device id of AR9485 to pci table
Date: Thu, 2 Dec 2010 03:07:11 -0800
Message-ID: <1291288031-3409-28-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index c5a523d..842c38d 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -30,6 +30,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
+	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ 0 }
 };
 
-- 
1.7.0.4

