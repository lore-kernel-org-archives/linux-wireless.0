Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58139 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbZLHOWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 09:22:00 -0500
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Seyfried <seife@sphairon.com>
Subject: [PATCH 1/2] ar9170usb: add Sphairon Homelink 1202 USB ID
Date: Tue,  8 Dec 2009 15:21:34 +0100
Message-Id: <1260282095-17042-2-git-send-email-stefan.seyfried@googlemail.com>
In-Reply-To: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stefan Seyfried <seife@sphairon.com>

Signed-off-by: Stefan Seyfried <seife@sphairon.com>
---
 drivers/net/wireless/ath/ar9170/usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index e0799d9..0f36118 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -84,6 +84,8 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x0cde, 0x0023) },
 	/* Z-Com UB82 ABG */
 	{ USB_DEVICE(0x0cde, 0x0026) },
+	/* Sphairon Homelink 1202 */
+	{ USB_DEVICE(0x0cde, 0x0027) },
 	/* Arcadyan WN7512 */
 	{ USB_DEVICE(0x083a, 0xf522) },
 	/* Planex GWUS300 */
-- 
1.6.5.3

