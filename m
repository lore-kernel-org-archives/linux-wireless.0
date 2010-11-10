Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:24992 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab0KJMNz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:13:55 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 04:13:42 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH v2 1/3] ath9k_htc: Update usb device ID list
Date: Wed, 10 Nov 2010 17:51:24 +0530
Message-ID: <1289391686-27632-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added new VID/PIDs into supported devices list

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
v2: Cc'd stable kernel

 drivers/net/wireless/ath/ath9k/hif_usb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f7ec31b..0e12277 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -36,8 +36,13 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x13D3, 0x3327) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3328) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3346) }, /* IMC Networks */
+	{ USB_DEVICE(0x13D3, 0x3348) }, /* Azurewave */
+	{ USB_DEVICE(0x13D3, 0x3349) }, /* Azurewave */
+	{ USB_DEVICE(0x13D3, 0x3350) }, /* Azurewave */
 	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
 	{ USB_DEVICE(0x083A, 0xA704) }, /* SMC Networks */
+	{ USB_DEVICE(0x040D, 0x3801) }, /* VIA */
+	{ USB_DEVICE(0x1668, 0x1200) }, /* Verizon */
 	{ },
 };
 
-- 
1.7.3.2

