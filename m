Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49407 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab0FNUPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:19 -0400
Received: by wwb18 with SMTP id 18so4215976wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:17 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/14] rt2x00: Fix typo in rt2800_config_txpower
Date: Mon, 14 Jun 2010 22:11:32 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142210.43525.IvDoorn@gmail.com> <201006142211.09880.IvDoorn@gmail.com>
In-Reply-To: <201006142211.09880.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142211.33421.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Fix typo in rt2800_config_txpower.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ae20e67..f158322 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1079,7 +1079,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 	u8 r1;
 
 	rt2800_bbp_read(rt2x00dev, 1, &r1);
-	rt2x00_set_field8(&reg, BBP1_TX_POWER, 0);
+	rt2x00_set_field8(&r1, BBP1_TX_POWER, 0);
 	rt2800_bbp_write(rt2x00dev, 1, r1);
 
 	rt2800_register_read(rt2x00dev, TX_PWR_CFG_0, &reg);
-- 
1.6.6.1

