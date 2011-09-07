Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39060 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1IGSLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 14:11:42 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so274569ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 11:11:41 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/5] rt2x00: Add LED_CFG register description
Date: Wed, 7 Sep 2011 20:10:25 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201109072010.04023.IvDoorn@gmail.com>
In-Reply-To: <201109072010.04023.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109072010.25836.IvDoorn@gmail.com> (sfid-20110907_201144_942103_37954E41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index c69a7d7..4778620 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -664,6 +664,9 @@
 
 /*
  * LED_CFG: LED control
+ * ON_PERIOD: LED active time (ms) during TX (only used for LED mode 1)
+ * OFF_PERIOD: LED inactive time (ms) during TX (only used for LED mode 1)
+ * SLOW_BLINK_PERIOD: LED blink interval in seconds (only used for LED mode 2)
  * color LED's:
  *   0: off
  *   1: blinking upon TX2
-- 
1.7.3.4
