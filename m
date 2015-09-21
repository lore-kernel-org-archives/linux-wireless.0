Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36342 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbIUM6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:58:44 -0400
Received: by padbj2 with SMTP id bj2so6752613pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 05:58:43 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/16] staging: wilc1000: make del_virtual_intf static
Date: Mon, 21 Sep 2015 21:58:14 +0900
Message-Id: <1442840306-9657-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_145846_738435_5C3DB7E8)
In-Reply-To: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes del_virtual_intf static. This function is used only at
wilc_wfi_cfgoperation.c file.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 40fd3ca..da04e50 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3362,7 +3362,7 @@ struct wireless_dev *add_virtual_intf(struct wiphy *wiphy, const char *name,
  *  @date	01 JUL 2012
  *  @version	1.0
  */
-int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
+static int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	PRINT_D(HOSTAPD_DBG, "Deleting virtual interface\n");
 	return 0;
-- 
2.5.1

