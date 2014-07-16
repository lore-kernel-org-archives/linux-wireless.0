Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56037 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaGPVXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:40 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so6912877wiv.13
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 19/21] staging: vt6656: main_usb remove dead module params macros
Date: Wed, 16 Jul 2014 22:22:09 +0100
Message-Id: <1405545731-6082-19-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232348_254667_CB84A2D4)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All these macros relate to module parameters already removed

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 49 ---------------------------------------
 1 file changed, 49 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0e65795..4bcdf8e 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -82,51 +82,9 @@ static int vnt_tx_buffers = TX_DESC_DEF0;
 module_param_named(tx_buffers, vnt_rx_buffers, int, 0644);
 MODULE_PARM_DESC(tx_buffers, "Number of receive usb tx buffers");
 
-
-#define CHANNEL_DEF 6
-
-/* PreambleType[] is the preamble length used for transmit.
-   0: indicate allows long preamble type
-   1: indicate allows short preamble type
-*/
-
-#define PREAMBLE_TYPE_DEF     1
 #define RTS_THRESH_DEF     2347
 #define FRAG_THRESH_DEF     2346
-#define DATA_RATE_DEF     13
-/* datarate[] index
-   0: indicate 1 Mbps   0x02
-   1: indicate 2 Mbps   0x04
-   2: indicate 5.5 Mbps 0x0B
-   3: indicate 11 Mbps  0x16
-   4: indicate 6 Mbps   0x0c
-   5: indicate 9 Mbps   0x12
-   6: indicate 12 Mbps  0x18
-   7: indicate 18 Mbps  0x24
-   8: indicate 24 Mbps  0x30
-   9: indicate 36 Mbps  0x48
-  10: indicate 48 Mbps  0x60
-  11: indicate 54 Mbps  0x6c
-  12: indicate 72 Mbps  0x90
-  13: indicate auto rate
-*/
-#define OP_MODE_DEF     0
-
-/* OpMode[] is used for transmit.
-   0: indicate infrastruct mode used
-   1: indicate adhoc mode used
-   2: indicate AP mode used
-*/
-
-/* PSMode[]
-   0: indicate disable power saving mode
-   1: indicate enable power saving mode
-*/
-
-#define PS_MODE_DEF     0
-
 #define SHORT_RETRY_DEF     8
-
 #define LONG_RETRY_DEF     4
 
 /* BasebandType[] baseband type selected
@@ -137,13 +95,6 @@ MODULE_PARM_DESC(tx_buffers, "Number of receive usb tx buffers");
 
 #define BBP_TYPE_DEF     2
 
-/* 80211hEnable[]
-   0: indicate disable 802.11h
-   1: indicate enable 802.11h
-*/
-
-#define X80211h_MODE_DEF     0
-
 /*
  * Static vars definitions
  */
-- 
2.0.1

