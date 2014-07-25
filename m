Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63799 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbaGYTxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:53:04 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so4644495wgg.31
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:53:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/12] staging: vt6656: rf.h clean up comments
Date: Fri, 25 Jul 2014 20:51:56 +0100
Message-Id: <1406317916-21884-12-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215328_833585_2EF1011B)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index 8cebb6a..3acdc65 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -32,9 +32,7 @@
 
 #include "device.h"
 
-//
-// Baseband RF pair definition in eeprom (Bits 6..0)
-//
+/* Baseband RF pair definition in eeprom (Bits 6..0) */
 #define RF_RFMD2959         0x01
 #define RF_MAXIMAG          0x02
 #define RF_AL2230           0x03
@@ -46,8 +44,8 @@
 #define RF_VT3226           0x09
 #define RF_AIROHA7230       0x0a
 #define RF_UW2453           0x0b
-#define RF_VT3226D0         0x0c //RobertYu:20051114
-#define RF_VT3342A0         0x0d //RobertYu:20060609
+#define RF_VT3226D0         0x0c /* RobertYu:20051114 */
+#define RF_VT3342A0         0x0d /* RobertYu:20060609 */
 #define RF_AL2230S          0x0e
 
 #define RF_EMU              0x80
-- 
2.0.1

