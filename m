Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933544AbXGaSed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:33 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:32 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 24/24] rt2x00: rt2x00 2.0.5
Date: Tue, 31 Jul 2007 20:37:43 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.43962.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 5c193b651a98b9913f0159d8337c5ee69ae490e5 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 31 Jul 2007 20:02:22 +0200
Subject: [PATCH 24/24] rt2x00: rt2x00 2.0.5

New release

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 777cd4a..c5c1773 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -41,7 +41,7 @@
  * Module information.
  * DRV_NAME should be set within the individual module source files.
  */
-#define DRV_VERSION	"2.0.4"
+#define DRV_VERSION	"2.0.5"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.2.4

