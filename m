Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:30801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbYAFWnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:43:01 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071365ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:43:00 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/12] rt2x00: Release rt2x00 2.0.14
Date: Sun, 6 Jan 2008 23:42:21 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062342.21271.IvDoorn@gmail.com> (sfid-20080106_224306_427796_8A101136)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d8585a0..94a8a7c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -43,7 +43,7 @@
 /*
  * Module information.
  */
-#define DRV_VERSION	"2.0.13"
+#define DRV_VERSION	"2.0.14"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.3.7

