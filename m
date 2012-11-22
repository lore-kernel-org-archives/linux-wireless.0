Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46380 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab2KVTAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:00:43 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3047402eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:00:42 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/13] wlcore: update commands enum to new fw api
Date: Thu, 22 Nov 2012 14:05:18 +0200
Message-Id: <1353585928-28666-4-git-send-email-eliad@wizery.com> (sfid-20121122_200108_523154_1924960D)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align the commands enum with the new fw api (8.5.0.0.28)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 3be2e92..d021305 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -151,8 +151,11 @@ enum wl1271_commands {
 	CMD_WFD_START_DISCOVERY	= 45,
 	CMD_WFD_STOP_DISCOVERY	= 46,
 	CMD_WFD_ATTRIBUTE_CONFIG	= 47,
-	CMD_NOP			= 48,
-	CMD_LAST_COMMAND,
+	CMD_GENERIC_CFG			= 48,
+	CMD_NOP				= 49,
+
+	/* start of 18xx specific commands */
+	CMD_DFS_CHANNEL_CONFIG		= 60,
 
 	MAX_COMMAND_ID = 0xFFFF,
 };
-- 
1.7.6.401.g6a319

