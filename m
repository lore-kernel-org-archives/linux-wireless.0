Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48429 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761162AbaGYTwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:41 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so1550484wiv.7
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/12] staging: vt6656: main_usb.c remove comments to functions nolonger present.
Date: Fri, 25 Jul 2014 20:51:51 +0100
Message-Id: <1406317916-21884-7-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215247_385483_F3DF5EBC)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fa0128f..87e89d7 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -27,20 +27,8 @@
  * Functions:
  *
  *   vt6656_probe - module initial (insmod) driver entry
- *   device_remove1 - module remove entry
- *   device_open - allocate dma/descripter resource & initial mac/bbp function
- *   device_xmit - asynchronous data tx function
- *   device_set_multi - set mac filter
- *   device_ioctl - ioctl entry
- *   device_close - shutdown mac/bbp & free dma/descriptor resource
- *   device_alloc_frag_buf - rx fragement pre-allocated function
  *   vnt_free_tx_bufs - free tx buffer function
- *   device_dma0_tx_80211- tx 802.11 frame via dma0
- *   device_dma0_xmit- tx PS buffered frame via dma0
  *   vnt_init_registers- initial MAC & BBP & RF internal registers.
- *   device_init_rings- initial tx/rx ring buffer
- *   device_init_defrag_cb- initial & allocate de-fragement buffer.
- *   device_tx_srv- tx interrupt service function
  *
  * Revision History:
  */
-- 
2.0.1

