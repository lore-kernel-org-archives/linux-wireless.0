Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44208 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0KFOts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:48 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so2253925ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:48 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/18] rt2x00: checkpatch.pl error fixes for rt2x00config.c
Date: Sat, 6 Nov 2010 15:46:17 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061545.42379.IvDoorn@gmail.com> <201011061545.59571.IvDoorn@gmail.com>
In-Reply-To: <201011061545.59571.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061546.18043.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

rt2x00config.c:136: ERROR: space required before the open parenthesis '('

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 54ffb5a..fca8f22 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -133,7 +133,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 */
 	if (!(ant->flags & ANTENNA_RX_DIVERSITY))
 		config.rx = rt2x00lib_config_antenna_check(config.rx, def->rx);
-	else if(config.rx == ANTENNA_SW_DIVERSITY)
+	else if (config.rx == ANTENNA_SW_DIVERSITY)
 		config.rx = active->rx;
 
 	if (!(ant->flags & ANTENNA_TX_DIVERSITY))
-- 
1.7.2.3

