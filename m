Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3539 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbZKIDAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 22:00:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] ath5k: add LED support for HP Compaq CQ60
Date: Sun,  8 Nov 2009 21:59:01 -0500
Message-Id: <1257735542-29658-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1257735542-29658-1-git-send-email-me@bobcopeland.com>
References: <1257735542-29658-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add GPIO configuration for the Compaq CQ60 laptop

Reported-by: David Dreggors <ddreggors@jumptv.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/led.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 7ce98bd..fca0cfa 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -71,6 +71,8 @@ static const struct pci_device_id ath5k_led_devices[] = {
 	{ ATH_SDEVICE(PCI_VENDOR_ID_AZWAVE, 0x1026), ATH_LED(3, 0) },
 	/* IBM ThinkPad AR5BXB6 (legovini@spiro.fisica.unipd.it) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_IBM, 0x058a), ATH_LED(1, 0) },
+	/* HP Compaq CQ60-206US (ddreggors@jumptv.com) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137a), ATH_LED(3, 1) },
 	/* HP Compaq C700 (nitrousnrg@gmail.com) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137b), ATH_LED(3, 1) },
 	/* IBM-specific AR5212 (all others) */
-- 
1.6.2.5


