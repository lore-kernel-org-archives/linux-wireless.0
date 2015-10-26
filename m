Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36170 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbJZAo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 20:44:58 -0400
Received: by pacfv9 with SMTP id fv9so177824915pac.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2015 17:44:58 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/4] staging: wilc1000: fix parameter name of function declaration
Date: Mon, 26 Oct 2015 09:44:43 +0900
Message-Id: <1445820285-14433-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20151026_014500_923339_7B48BE47)
In-Reply-To: <1445820285-14433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445820285-14433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes struct host_if_drv of host_int_set_WEPDefaultKeyID
function declaration from hWFIDrv to hif_drv in host_interface.h
With this change, first parameter name of this function declaration and
definition has same name as hif_drv.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a125233..7631757 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -384,7 +384,7 @@ int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index);
+int host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index);
 
 /**
  *  @brief              sets WEP deafault key
-- 
2.6.1

