Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34677 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbaEQIxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:01 -0400
Received: by mail-wi0-f178.google.com with SMTP id hm4so2027146wib.5
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/22] staging: vt6656: desc.h Remove unused macros
Date: Sat, 17 May 2014 09:50:26 +0100
Message-Id: <1400316639-4430-9-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105311_371256_74E3D2B8)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 171315a..617d479 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -39,28 +39,15 @@
 /* max transmit or receive buffer size */
 #define CB_MAX_BUF_SIZE     2900U       /* NOTE: must be multiple of 4 */
 
-/* max TX buffer size */
-#define CB_MAX_TX_BUF_SIZE        CB_MAX_BUF_SIZE
-/* max RX buffer size when not use Multi-RD */
-#define CB_MAX_RX_BUF_SIZE_NORMAL CB_MAX_BUF_SIZE
-
-#define CB_BEACON_BUF_SIZE  512U        /* default beacon buffer size */
-
 #define MAX_TOTAL_SIZE_WITH_ALL_HEADERS CB_MAX_BUF_SIZE
 
 #define MAX_INTERRUPT_SIZE              32
 
-#define RX_BLOCKS           64          /* from 0x60 to 0xA0 */
-#define TX_BLOCKS           32          /* from 0xA0 to 0xC0 */
-
 #define CB_MAX_RX_DESC      128         /* max # of descriptors */
 #define CB_MIN_RX_DESC      16          /* min # of RX descriptors */
 #define CB_MAX_TX_DESC      128         /* max # of descriptors */
 #define CB_MIN_TX_DESC      16          /* min # of TX descriptors */
 
-#define CB_RD_NUM           64          /* default # of RD */
-#define CB_TD_NUM           64          /* default # of TD */
-
 /*
  * bits in the RSR register
  */
-- 
1.9.1

