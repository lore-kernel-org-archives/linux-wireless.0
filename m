Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:52425 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024Ab3ACIBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 03:01:05 -0500
Date: Thu, 3 Jan 2013 13:24:44 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 5/5] mwl8k: bump firmware API to 3
Message-ID: <20130103075440.GA20523@markyou.marvell.com> (sfid-20130103_090110_296162_E16217E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New firmware is required to support
a) Add support for additional ampdu streams
b) Handle corresponding watchdog events to destroy ampdu streams

Bumping firmware API version by one.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 51ae9e9..5717e15 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5319,7 +5319,7 @@ enum {
 	MWL8366,
 };
 
-#define MWL8K_8366_AP_FW_API 2
+#define MWL8K_8366_AP_FW_API 3
 #define _MWL8K_8366_AP_FW(api) "mwl8k/fmimage_8366_ap-" #api ".fw"
 #define MWL8K_8366_AP_FW(api) _MWL8K_8366_AP_FW(api)
 
-- 
1.8.0.3

