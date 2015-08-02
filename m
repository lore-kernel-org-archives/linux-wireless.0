Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36732 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbHBKwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 06:52:19 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH] Staging: wilc1000 :Insert blank line after declaration
Date: Sun,  2 Aug 2015 16:21:59 +0530
Message-Id: <1438512719-22877-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150802_125257_997499_4F499838)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following checkpatch.pl warning:

WARNING: Missing a blank line after declarations

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 9cb46bb..a6d809f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1152,6 +1152,7 @@ void ProcessShortWid(char *pcPacket, s32 *ps32PktLen,
 	u16 *pu16val = (u16 *)ps8WidVal;
 	u16 u16val = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set SHORT val 0x%x ,NULL structure\n", u16val);
 		return;
-- 
2.1.0

