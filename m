Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51773 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbbIKDE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 23:04:27 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 1/2] staging: wilc1000: remove unused enum
Date: Fri, 11 Sep 2015 12:04:19 +0900
Message-ID: <1441940660-5925-2-git-send-email-tony.cho@atmel.com> (sfid-20150911_050430_587407_C8FCE862)
In-Reply-To: <1441940660-5925-1-git-send-email-tony.cho@atmel.com>
References: <1441940660-5925-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes a unused enum tenuFrameClass.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 58e6108..450c3ff 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -88,14 +88,6 @@ typedef enum {
 	FRAME_SUBTYPE_FORCE_32BIT  = 0xFFFFFFFF
 } tenuFrmSubtype;
 
-/* Basic Frame Classes */
-typedef enum {
-	CLASS1_FRAME_TYPE      = 0x00,
-	CLASS2_FRAME_TYPE      = 0x01,
-	CLASS3_FRAME_TYPE      = 0x02,
-	FRAME_CLASS_FORCE_32BIT  = 0xFFFFFFFF
-} tenuFrameClass;
-
 /* Element ID  of various Information Elements */
 typedef enum {
 	ISSID               = 0,   /* Service Set Identifier         */
-- 
1.9.1

