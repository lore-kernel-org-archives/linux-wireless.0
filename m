Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53126 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaKEVJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:38 -0500
Received: by mail-wi0-f174.google.com with SMTP id d1so13653309wiv.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:37 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/11] staging: vt6655: mac.c/h remove member type comments
Date: Wed,  5 Nov 2014 21:08:50 +0000
Message-Id: <1415221739-3045-2-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220941_188816_80EEB69E)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 10 ----------
 drivers/staging/vt6655/mac.h |  6 ------
 2 files changed, 16 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 122a6a3..2ea74a1 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -71,16 +71,6 @@
 #include "tmacro.h"
 #include "mac.h"
 
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 /*
  * Description:
  *      Read All MAC Registers to buffer
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 23162a9..3f37014 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -964,12 +964,6 @@ do {								\
 #define MACvSetRFLE_LatchBase(dwIoBase)                                 \
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_RFLEOPT)
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 void MACvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyMacRegs);
 
 bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
-- 
2.1.0

