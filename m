Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from woodchuck.wormnet.eu ([77.75.105.223]:55303 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZDGWHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 18:07:36 -0400
Date: Tue, 7 Apr 2009 22:59:56 +0100 (BST)
From: Jamie Lentin <jm@lentin.co.uk>
To: kalle.valo@iki.fi
cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Add device ID for OQO model 01+
Message-ID: <alpine.DEB.1.10.0904072237270.24512@woodchuck.wormnet.eu> (sfid-20090408_000740_759462_DFC9097F)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add USB device ID for OQO 01+'s internal wireless LAN

An OQO employee mentions the chip's true identity here:-
    ftp://ftp.oqo.com/unsupported/linux/OQOLinux.html

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
---
  drivers/net/wireless/at76c50x-usb.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c 
b/drivers/net/wireless/at76c50x-usb.c
index 0c02f1c..744f4f4 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -250,6 +250,8 @@ static struct usb_device_id dev_table[] = {
  	{ USB_DEVICE(0x03eb, 0x7617), USB_DEVICE_DATA(BOARD_505A) },
  	/* Siemens Gigaset USB WLAN Adapter 11 */
  	{ USB_DEVICE(0x1690, 0x0701), USB_DEVICE_DATA(BOARD_505A) },
+	/* OQO Model 01+ Internal Wi-Fi */
+	{ USB_DEVICE(0x1557, 0x0002), USB_DEVICE_DATA(BOARD_505A) },
  	/*
  	 * at76c505amx-rfmd
  	 */
-- 
1.6.2.1

