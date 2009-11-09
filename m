Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3540 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZKIDAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 22:00:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] ath5k: add LED definition for BenQ Joybook R55v
Date: Sun,  8 Nov 2009 21:59:02 -0500
Message-Id: <1257735542-29658-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1257735542-29658-1-git-send-email-me@bobcopeland.com>
References: <1257735542-29658-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup the GPIOs for the BenQ Joybook netbook.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/led.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index fca0cfa..d495890 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -65,6 +65,8 @@ static const struct pci_device_id ath5k_led_devices[] = {
 	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0422), ATH_LED(1, 1) },
 	/* E-machines E510 (tuliom@gmail.com) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0428), ATH_LED(3, 0) },
+	/* BenQ Joybook R55v (nowymarluk@wp.pl) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0100), ATH_LED(1, 0) },
 	/* Acer Extensa 5620z (nekoreeve@gmail.com) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0105), ATH_LED(3, 0) },
 	/* Fukato Datacask Jupiter 1014a (mrb74@gmx.at) */
-- 
1.6.2.5


