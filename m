Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50559 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1IGSLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 14:11:46 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so5210512eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 11:11:45 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/5] rt2x00: Update some TX descriptor
Date: Wed, 7 Sep 2011 20:11:03 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201109072010.04023.IvDoorn@gmail.com> <201109072010.25836.IvDoorn@gmail.com> <201109072010.45905.IvDoorn@gmail.com>
In-Reply-To: <201109072010.45905.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109072011.04627.IvDoorn@gmail.com> (sfid-20110907_201149_553887_B829B226)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index d448f5c..349008d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -288,8 +288,8 @@ enum txentry_desc_flags {
  * @signal: PLCP signal.
  * @service: PLCP service.
  * @msc: MCS.
- * @stbc: STBC.
- * @ba_size: BA size.
+ * @stbc: Use Space Time Block Coding (only available for MCS rates < 8).
+ * @ba_size: Size of the recepients RX reorder buffer - 1.
  * @rate_mode: Rate mode (See @enum rate_modulation).
  * @mpdu_density: MDPU density.
  * @retry_limit: Max number of retries.
-- 
1.7.3.4
