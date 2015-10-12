Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12601 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbJLH6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:58:06 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 14/41] staging: wilc1000: remove unused struct tstrBssTable
Date: Mon, 12 Oct 2015 16:55:48 +0900
Message-ID: <1444636575-2486-14-git-send-email-tony.cho@atmel.com> (sfid-20151012_095810_854039_8BF37185)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes struct tstrBssTable with related comment.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 77aefaf..89b6cdd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -436,12 +436,6 @@ typedef struct _tstrJoinBssParam {
 	u8 au8Interval[4];
 	u8 au8StartTime[4];
 } tstrJoinBssParam;
-/*a linked list table containing needed join parameters entries for each AP found in most recent scan*/
-typedef struct _tstrBssTable {
-	u8 u8noBssEntries;
-	tstrJoinBssParam *head;
-	tstrJoinBssParam *tail;
-} tstrBssTable;
 
 typedef enum {
 	SCAN_TIMER = 0,
-- 
1.9.1

