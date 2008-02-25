Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:38127 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbYBYWY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:24:26 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1503896fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:24:25 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 6/6] rt2x00: Release rt2x00 2.1.3
Date: Mon, 25 Feb 2008 23:22:13 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802252320.11809.IvDoorn@gmail.com>
In-Reply-To: <200802252320.11809.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802252322.13292.IvDoorn@gmail.com> (sfid-20080225_222429_252397_CA47B0B9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d0f027a..fd65fcc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -44,7 +44,7 @@
 /*
  * Module information.
  */
-#define DRV_VERSION	"2.1.2"
+#define DRV_VERSION	"2.1.3"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
-- 
1.5.3.2

