Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5664 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbbIPBob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 21:44:31 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 05/10] staging: wilc1000: remove unnecessary extern function declaration
Date: Wed, 16 Sep 2015 10:43:50 +0900
Message-ID: <1442367835-30733-6-git-send-email-tony.cho@atmel.com> (sfid-20150916_034433_507060_8418F8F6)
In-Reply-To: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
References: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Function NetworkInfoReceived, GnrlAsyncInfoReceived and
host_int_ScanCompleteReceived are declared in the header file already.
Just removes the declaration and comments.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index a0b0d97..b514d09 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -136,14 +136,6 @@ typedef struct {
 /* Extern Variable Declarations                                              */
 /*****************************************************************************/
 
-
-/*****************************************************************************/
-/* Extern Function Declarations                                              */
-/*****************************************************************************/
-extern s32 SendRawPacket(s8 *ps8Packet, s32 s32PacketLen);
-extern void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length);
-extern void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length);
-extern void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length);
 /*****************************************************************************/
 /* Global Variables                                                          */
 /*****************************************************************************/
-- 
1.9.1

