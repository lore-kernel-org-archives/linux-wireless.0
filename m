Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35227 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbbFZOkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 10:40:32 -0400
Received: by wgjx7 with SMTP id x7so16963380wgj.2
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2015 07:40:31 -0700 (PDT)
Date: Fri, 26 Jun 2015 16:46:37 +0200
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-kernel@vger.kernel.orgr
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 4/4] staging: wilc1000: fix typos in PRINT_ERR()
Message-ID: <20150626144634.GA30097@goodgumbo.baconseed.org> (sfid-20150626_164035_819008_B2A3B7D5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix typo "packe" to "packet".

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 79b7c2a..1915fc6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3688,7 +3688,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 
-		PRINT_ER("Failed to send add station config packe\n");
+		PRINT_ER("Failed to send add station config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
 	}
 
@@ -3735,7 +3735,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
 	if (s32Error) {
 
-		PRINT_ER("Failed to send add station config packe\n");
+		PRINT_ER("Failed to send add station config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
 	}
 
-- 
2.1.4

