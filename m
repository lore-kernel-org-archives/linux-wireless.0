Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:59572 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYCIVvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:05 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1362518fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:04 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 11/24] rt2x00: Fix trivial log message
Date: Sun, 9 Mar 2008 22:43:58 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092243.58693.IvDoorn@gmail.com> (sfid-20080309_215514_796123_91439800)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis Correia <luis.f.correia@gmail.com>

Fix trivial log message.

Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    3 ++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index b6c6f7d..b9e2f3a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -294,7 +294,8 @@ static void rt2500usb_led_brightness(struct led_classdev *led_cdev,
 
 	if (in_atomic()) {
 		NOTICE(led->rt2x00dev,
-		       "Ignoring LED brightness command for led %d", led->type);
+		       "Ignoring LED brightness command for led %d\n",
+		       led->type);
 		return;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d0c0fde..5e9a0c0 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -292,7 +292,8 @@ static void rt73usb_led_brightness(struct led_classdev *led_cdev,
 
 	if (in_atomic()) {
 		NOTICE(led->rt2x00dev,
-		       "Ignoring LED brightness command for led %d", led->type);
+		       "Ignoring LED brightness command for led %d\n",
+		       led->type);
 		return;
 	}
 
-- 
1.5.4.3

