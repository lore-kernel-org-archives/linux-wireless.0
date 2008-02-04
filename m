Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46290 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYBDFFU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 00:05:20 -0500
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 78F68619055
	for <linux-wireless@vger.kernel.org>; Mon,  4 Feb 2008 00:05:19 -0500 (EST)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] at76_usb: Add ID for Uniden PCW100
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2008 00:05:19 -0500
Message-ID: <20080204050518.2696.50289.stgit@dv.roinet.com> (sfid-20080204_050534_832644_B7C108A2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested and reported by Lior Silberman.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index d2e3c55..b95718a 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -191,6 +191,8 @@ static struct usb_device_id dev_table[] = {
 	{USB_DEVICE(0x07aa, 0x0011), USB_DEVICE_DATA(BOARD_503)},
 	/* Corega Wireless LAN USB-11 mini2 */
 	{USB_DEVICE(0x07aa, 0x0018), USB_DEVICE_DATA(BOARD_503)},
+	/* Uniden PCW100 */
+	{USB_DEVICE(0x05dd, 0xff35), USB_DEVICE_DATA(BOARD_503)},
 	/*
 	 * at76c503-rfmd-acc
 	 */
