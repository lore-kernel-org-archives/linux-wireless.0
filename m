Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:51820 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbYLBRXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 12:23:20 -0500
Received: by ug-out-1314.google.com with SMTP id 39so3119846ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 09:23:18 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/5] rt2x00: Release rt2x00 2.2.3
Date: Tue, 2 Dec 2008 18:20:59 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200812021819.23756.IvDoorn@gmail.com> <200812021820.22750.IvDoorn@gmail.com> <200812021820.42808.IvDoorn@gmail.com>
In-Reply-To: <200812021820.42808.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812021820.59537.IvDoorn@gmail.com> (sfid-20081202_182333_130208_9A15D17F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 03d34bb..39ecf3b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -44,7 +44,7 @@
 /*
  * Module information.
  */
-#define DRV_VERSION	"2.2.2"
+#define DRV_VERSION	"2.2.3"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.6.1

