Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:47236 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772Ab0JEMCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 08:02:21 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o95C2Kra019546
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 15:02:20 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl1271: remove deprecated __attribute__ ((packed))
Date: Tue,  5 Oct 2010 15:02:19 +0300
Message-Id: <1286280139-12378-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One __attribute__ ((packed)) has been accidentally introduced in commit
be86cbea1e9c3a4dd8faedcfa327495d09fe3531.  This patch changes it to __packed.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index ed80bec..a0caf4f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -454,6 +454,6 @@ struct wl1271_cmd_set_sta_state {
 
 	u8 state;
 	u8 padding[3];
-} __attribute__ ((packed));
+} __packed;
 
 #endif /* __WL1271_CMD_H__ */
-- 
1.7.0.4

