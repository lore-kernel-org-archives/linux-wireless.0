Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33007 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab0FNUPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:15 -0400
Received: by mail-wy0-f174.google.com with SMTP id 40so4235810wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:14 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/14] rt2x00: Add comment about BBP1_TX_POWER
Date: Mon, 14 Jun 2010 22:10:42 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142209.42709.IvDoorn@gmail.com> <201006142210.10378.IvDoorn@gmail.com>
In-Reply-To: <201006142210.10378.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142210.43525.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Add a comment about the meaning of BBP1_TX_POWER stating all possible values.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 16bfaa8..b308421 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1557,7 +1557,9 @@ struct mac_iveiv_entry {
  */
 
 /*
- * BBP 1: TX Antenna
+ * BBP 1: TX Antenna & Power
+ * POWER: 0 - normal, 1 - drop tx power by 6dBm, 2 - drop tx power by 12dBm,
+ *	3 - increase tx power by 6dBm
  */
 #define BBP1_TX_POWER			FIELD8(0x07)
 #define BBP1_TX_ANTENNA			FIELD8(0x18)
-- 
1.6.6.1

