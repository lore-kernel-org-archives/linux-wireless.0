Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:41276 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZKECzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 21:55:44 -0500
From: Keng-Yu Lin <keng-yu.lin@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>
Subject: [PATCH] ath5k: add LED support for Acer Aspire One AO751h/AO531h
Date: Thu,  5 Nov 2009 10:55:29 +0800
Message-Id: <1257389729-26491-1-git-send-email-keng-yu.lin@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add LED support for a Foxconn AR242X module, found on
the Acer Aspire One models AO751h/AO531h

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
---
 drivers/net/wireless/ath/ath5k/led.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index b767c3b..21a42a1 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -59,6 +59,8 @@ static const struct pci_device_id ath5k_led_devices[] = {
 	{ ATH_SDEVICE(PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID), ATH_LED(1, 1) },
 	/* Acer Aspire One A150 (maximlevitsky@gmail.com) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, 0xe008), ATH_LED(3, 0) },
+	/* Acer Aspire One AO531h AO751h */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, 0xe00d), ATH_LED(3, 0) },
 	/* Acer Ferrari 5000 (russ.dill@gmail.com) */
 	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0422), ATH_LED(1, 1) },
 	/* E-machines E510 (tuliom@gmail.com) */
-- 
1.6.3.3

