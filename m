Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:32841 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbbIPMLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 08:11:10 -0400
From: Aparna Karuthodi <kdasaparna@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, johnny.kim@atmel.com,
	Aparna Karuthodi <kdasaparna@gmail.com>
Subject: [PATCH] staging: wilc1000: Added new lines
Date: Wed, 16 Sep 2015 17:42:42 +0530
Message-Id: <1442405562-6115-1-git-send-email-kdasaparna@gmail.com> (sfid-20150916_141140_935145_AFAFE737)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added new lines after declarations for removing coding style warnings
detected by checkpatch.The warnings are given below:

1561: WARNING: Missing a blank line after declarations
1551: WARNING: Missing a blank line after declarations
1329: WARNING: Missing a blank line after declarations
1213: WARNING: Missing a blank line after declarations
1158: WARNING: Missing a blank line after declarations
1104: WARNING: Missing a blank line after declarations
675: WARNING: Missing a blank line after declarations

Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 5241699..dad03f3 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -669,6 +669,7 @@ INLINE u16 get_asoc_id(u8 *data)
 s32 CoreConfiguratorInit(void)
 {
 	s32 s32Error = WILC_SUCCESS;
+
 	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
 
 	sema_init(&SemHandleSendPkt, 1);
@@ -1098,6 +1099,7 @@ void ProcessCharWid(char *pcPacket, s32 *ps32PktLen,
 	u8 *pu8val = (u8 *)ps8WidVal;
 	u8 u8val = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set CHAR val 0x%x ,NULL structure\n", u8val);
 		return;
@@ -1152,6 +1154,7 @@ void ProcessShortWid(char *pcPacket, s32 *ps32PktLen,
 	u16 *pu16val = (u16 *)ps8WidVal;
 	u16 u16val = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set SHORT val 0x%x ,NULL structure\n", u16val);
 		return;
@@ -1207,6 +1210,7 @@ void ProcessIntWid(char *pcPacket, s32 *ps32PktLen,
 	u32 *pu32val = (u32 *)ps8WidVal;
 	u32 u32val = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set INT val 0x%x , NULL structure\n", u32val);
 		return;
@@ -1323,6 +1327,7 @@ void ProcessStrWid(char *pcPacket, s32 *ps32PktLen,
 	u16 u16MsgLen = 0;
 	u16 idx    = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set STR val, NULL structure\n");
 		return;
@@ -1545,6 +1550,7 @@ s32 further_process_response(u8 *resp,
 	case WID_SHORT:
 	{
 		u16 *pu16val = (u16 *)(pstrWIDresult->ps8WidVal);
+
 		cfg_sht = MAKE_WORD16(resp[idx], resp[idx + 1]);
 		/*Set local copy of WID*/
 		/* pstrWIDresult->ps8WidVal = (s8*)(s32)cfg_sht; */
@@ -1555,6 +1561,7 @@ s32 further_process_response(u8 *resp,
 	case WID_INT:
 	{
 		u32 *pu32val = (u32 *)(pstrWIDresult->ps8WidVal);
+
 		cfg_int = MAKE_WORD32(
 				MAKE_WORD16(resp[idx], resp[idx + 1]),
 				MAKE_WORD16(resp[idx + 2], resp[idx + 3])
-- 
1.7.9.5

