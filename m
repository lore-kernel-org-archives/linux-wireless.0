Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34116 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbcDDLFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 07:05:11 -0400
Received: by mail-pa0-f68.google.com with SMTP id hb4so4685892pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 04:05:11 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/8] staging: wilc1000: remove block scope braces and fix indentation
Date: Mon,  4 Apr 2016 20:04:45 +0900
Message-Id: <1459767890-9709-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160404_130518_196620_1D29B556)
In-Reply-To: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary block scope braces and fix indentation of
the codes.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index aa95eda..e978208 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -783,13 +783,11 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 		u32WidsCount++;
 	}
 
-	{
-		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
-		strWIDList[u32WidsCount].type = WID_BIN_DATA;
-		strWIDList[u32WidsCount].val = pstrHostIFscanAttr->ies;
-		strWIDList[u32WidsCount].size = pstrHostIFscanAttr->ies_len;
-		u32WidsCount++;
-	}
+	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
+	strWIDList[u32WidsCount].type = WID_BIN_DATA;
+	strWIDList[u32WidsCount].val = pstrHostIFscanAttr->ies;
+	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->ies_len;
+	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
-- 
2.8.0

