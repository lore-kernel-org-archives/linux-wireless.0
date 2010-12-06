Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36158 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0LFMcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 07:32:45 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 04:32:31 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V3 27/27] ath9k: Add device id of AR9485 to pci table
Date: Mon, 6 Dec 2010 04:28:00 -0800
Message-ID: <1291638480-8950-28-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291638480-8950-1-git-send-email-vasanth@atheros.com>
References: <1291638480-8950-1-git-send-email-vasanth@atheros.com>
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

