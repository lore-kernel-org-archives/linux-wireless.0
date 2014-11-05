Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64086 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaKEVJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:36 -0500
Received: by mail-wi0-f177.google.com with SMTP id ex7so3252963wid.10
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:35 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/11] staging: vt6655: mac remove dead variable TxRate_iwconfig
Date: Wed,  5 Nov 2014 21:08:49 +0000
Message-Id: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220939_595166_A0A8AE6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 1 -
 drivers/staging/vt6655/mac.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 955dbfe..122a6a3 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -71,7 +71,6 @@
 #include "tmacro.h"
 #include "mac.h"
 
-unsigned short TxRate_iwconfig;//2008-5-8 <add> by chester
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 5391277..23162a9 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -970,7 +970,6 @@ do {								\
 
 /*---------------------  Export Functions  --------------------------*/
 
-extern unsigned short TxRate_iwconfig;//2008-5-8 <add> by chester
 void MACvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyMacRegs);
 
 bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
-- 
2.1.0

