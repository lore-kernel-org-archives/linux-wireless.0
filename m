Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbbHaIzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 04:55:44 -0400
Date: Mon, 31 Aug 2015 10:55:05 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Michael Coates <michlinux@hotmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2800usb: add usb ID 1b75:3070 for Airlive WT-2000USB
Message-ID: <20150831085504.GA2961@redhat.com> (sfid-20150831_105547_476037_A576EAA0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brand: Airlive (Ovislink Corp.)
Name: Turbo-G USB Adaptor
Model: WT-2000USB
USB ID: 1b75:3070

Reported-and-tested-by: Michael Coates <michlinux@hotmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5932306..bf9afbf 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1114,6 +1114,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0db0, 0x871c) },
 	{ USB_DEVICE(0x0db0, 0x899a) },
 	/* Ovislink */
+	{ USB_DEVICE(0x1b75, 0x3070) },
 	{ USB_DEVICE(0x1b75, 0x3071) },
 	{ USB_DEVICE(0x1b75, 0x3072) },
 	{ USB_DEVICE(0x1b75, 0xa200) },
-- 
1.7.1
