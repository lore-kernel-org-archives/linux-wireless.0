Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34786 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbbJ2M3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 08:29:50 -0400
Received: by padhk11 with SMTP id hk11so40053161pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 05:29:50 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/12] staging: wilc1000: fix parameter name of host_int_del_station
Date: Thu, 29 Oct 2015 21:29:20 +0900
Message-Id: <1446121768-4953-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151029_132953_057839_58066D36)
In-Reply-To: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes struct host_if_drv of host_int_del_station function
declaration from hWFIDrv to hif_drv.
With this change, first parameter name of this function declaration and
definition has same name as hif_drv.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9eb1b3b..083def57 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -979,7 +979,7 @@ s32 host_int_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALE
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-int host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
+int host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr);
 
 /*!
  *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv,
-- 
2.6.1

