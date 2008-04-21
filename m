Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:52877 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762276AbYDURAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:15 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2556605fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:00:14 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 9/9] rt2x00: Release rt2x00 2.1.5
Date: Mon, 21 Apr 2008 19:02:35 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com>
In-Reply-To: <200804211858.46659.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804211902.35377.IvDoorn@gmail.com> (sfid-20080421_190108_225499_5DB5CD96)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 92656d0..48a9af4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -44,7 +44,7 @@
 /*
  * Module information.
  */
-#define DRV_VERSION	"2.1.4"
+#define DRV_VERSION	"2.1.5"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.4.5

