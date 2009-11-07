Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53587 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbZKGV4G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 16:56:06 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 21:56:08 +0000
Message-ID: <1257630968.15927.449.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 45/75] at76c50x-usb: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/at76c50x-usb.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index e559dc9..0a917e4 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -121,6 +121,14 @@ static struct fwentry firmwares[] = {
 	[BOARD_505A] = { "atmel_at76c505a-rfmd2958.bin" },
 	[BOARD_505AMX] = { "atmel_at76c505amx-rfmd.bin" },
 };
+MODULE_FIRMWARE("atmel_at76c503-i3861.bin");
+MODULE_FIRMWARE("atmel_at76c503-i3863.bin");
+MODULE_FIRMWARE("atmel_at76c503-rfmd.bin");
+MODULE_FIRMWARE("atmel_at76c503-rfmd-acc.bin");
+MODULE_FIRMWARE("atmel_at76c505-rfmd.bin");
+MODULE_FIRMWARE("atmel_at76c505-rfmd2958.bin");
+MODULE_FIRMWARE("atmel_at76c505a-rfmd2958.bin");
+MODULE_FIRMWARE("atmel_at76c505amx-rfmd.bin");
 
 #define USB_DEVICE_DATA(__ops)	.driver_info = (kernel_ulong_t)(__ops)
 
-- 
1.6.5.2



