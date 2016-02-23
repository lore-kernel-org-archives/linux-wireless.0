Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36640 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbcBWGib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 01:38:31 -0500
Received: by mail-pf0-f174.google.com with SMTP id e127so107004974pfe.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2016 22:38:30 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 7/7] staging: wilc1000: handle_cfg_param: remove unnecessary whitespace
Date: Tue, 23 Feb 2016 15:38:03 +0900
Message-Id: <1456209483-20345-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160223_073847_203624_176DAD90)
In-Reply-To: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary whitespace before a quoted newline found
by checkpatch
WARNING: unnecessary whitespace before a quoted newline

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fb809a4..2ace069 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -501,7 +501,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[i].size = sizeof(char);
 			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->auth_type;
 		} else {
-			netdev_err(vif->ndev, "Impossible value \n");
+			netdev_err(vif->ndev, "Impossible value\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
-- 
2.7.1

