Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44208 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0KFOtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:50 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so2253925ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/18] rt2x00: checkpatch.pl error fixes for rt2x00dev.c
Date: Sat, 6 Nov 2010 15:46:36 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061545.59571.IvDoorn@gmail.com> <201011061546.18043.IvDoorn@gmail.com>
In-Reply-To: <201011061546.18043.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061546.37042.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

rt2x00dev.c:689: ERROR: spaces required around that '=' (ctx:WxV)

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b6822cd..942b4af 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -686,7 +686,7 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
 {
 	entry->flags = 0;
 	entry->bitrate = rate->bitrate;
-	entry->hw_value =index;
+	entry->hw_value = index;
 	entry->hw_value_short = index;
 
 	if (rate->flags & DEV_RATE_SHORT_PREAMBLE)
-- 
1.7.2.3

