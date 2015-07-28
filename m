Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48057 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbbG1ItR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:49:17 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/21] staging: wilc1000: remove multiple blank lines
Date: Tue, 28 Jul 2015 17:47:30 +0900
Message-ID: <1438073261-28315-12-git-send-email-tony.cho@atmel.com> (sfid-20150728_104925_286777_3DD2502A)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Jude.Lee" <jude.lee@atmel.com>

This patch removes the warnings reported by checkpatch.pl for using
multiple blank lines.

Signed-off-by: Jude.Lee <jude.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 9059c8d..3b4b01b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -8,7 +8,6 @@
  *  @version	1.0
  */
 
-
 #ifndef CORECONFIGURATOR_H
 #define CORECONFIGURATOR_H
 
@@ -42,7 +41,6 @@ extern u16 g_num_total_switches;
 #define AID_LEN                 2
 #define IE_HDR_LEN              2
 
-
 /* Operating Mode: SET */
 #define SET_CFG              0
 /* Operating Mode: GET */
@@ -59,15 +57,12 @@ extern u16 g_num_total_switches;
 #define MAC_CONNECTED                1
 #define MAC_DISCONNECTED             0
 
-
-
 /*****************************************************************************/
 /* Function Macros                                                           */
 /*****************************************************************************/
 #define MAKE_WORD16(lsb, msb) ((((u16)(msb) << 8) & 0xFF00) | (lsb))
 #define MAKE_WORD32(lsw, msw) ((((u32)(msw) << 16) & 0xFFFF0000) | (lsw))
 
-
 /*****************************************************************************/
 /* Type Definitions                                                                                                                       */
 /*****************************************************************************/
@@ -140,7 +135,6 @@ typedef struct {
 	u16 u16RespIEsLen;
 } tstrConnectRespInfo;
 
-
 typedef struct {
 	u8 au8bssid[6];
 	u8 *pu8ReqIEs;
@@ -150,8 +144,6 @@ typedef struct {
 	u16 u16ConnectStatus;
 } tstrConnectInfo;
 
-
-
 typedef struct {
 	u16 u16reason;
 	u8 *ie;
-- 
1.9.1

