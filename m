Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45770 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965656AbaDJJgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 05:36:41 -0400
From: Frederic Danis <frederic.danis@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, pizza@shaftnet.org,
	Frederic Danis <frederic.danis@linux.intel.com>
Subject: [PATCH] cw1200: Fix cw1200_debug_link_id
Date: Thu, 10 Apr 2014 11:36:38 +0200
Message-Id: <1397122598-22547-1-git-send-email-frederic.danis@linux.intel.com> (sfid-20140410_113652_103081_C6576CC0)
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This array is used in debug string to display cw1200_link_status
defined in drivers/net/wireless/cw1200/cw1200.h.

Add missing strings for CW1200_LINK_RESET and CW1200_LINK_RESET_REMAP.

Signed-off-by: Frederic Danis <frederic.danis@linux.intel.com>
---
 drivers/net/wireless/cw1200/debug.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/cw1200/debug.c b/drivers/net/wireless/cw1200/debug.c
index e323b4d..34f97c3 100644
--- a/drivers/net/wireless/cw1200/debug.c
+++ b/drivers/net/wireless/cw1200/debug.c
@@ -41,6 +41,8 @@ static const char * const cw1200_debug_link_id[] = {
 	"REQ",
 	"SOFT",
 	"HARD",
+	"RESET",
+	"RESET_REMAP",
 };
 
 static const char *cw1200_debug_mode(int mode)
-- 
1.7.9.5

