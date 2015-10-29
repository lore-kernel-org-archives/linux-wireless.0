Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:32990 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942AbbJ2XSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 19:18:16 -0400
Received: by padfb7 with SMTP id fb7so5896853pad.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 16:18:16 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 08/12] staging: wilc1000: fix parameter name of host_int_add_station
Date: Fri, 30 Oct 2015 08:17:44 +0900
Message-Id: <1446160668-10747-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151030_001845_665477_E66A4ADB)
In-Reply-To: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes struct host_if_drv of host_int_add_station function
declaration from hWFIDrv to hif_drv.
With this change, first parameter name of this function declaration and
definition has same name as hif_drv.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 11/12 patch is changed.

 drivers/staging/wilc1000/host_interface.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3fcff7a..7c9c4c6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -948,7 +948,7 @@ int host_int_del_beacon(struct host_if_drv *hif_drv);
  *  @date		12 July 2012
  *  @version		1.0 Description
  */
-int host_int_add_station(struct host_if_drv *hWFIDrv,
+int host_int_add_station(struct host_if_drv *hif_drv,
 			 struct add_sta_param *pstrStaParams);
 
 /*!
-- 
2.6.1

