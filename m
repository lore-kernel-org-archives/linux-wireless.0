Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37642 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1BTM6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 07:58:13 -0500
Received: by eye27 with SMTP id 27so2477444eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 04:58:09 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/8] rt2x00: Remove superfluos empty line
Date: Sun, 20 Feb 2011 13:56:26 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201102201354.53379.IvDoorn@gmail.com> <201102201355.47592.IvDoorn@gmail.com> <201102201356.08735.IvDoorn@gmail.com>
In-Reply-To: <201102201356.08735.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102201356.27555.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00ht.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index b7ad46e..03d9579 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -69,7 +69,6 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 			txdesc->mcs |= 0x08;
 	}
 
-
 	/*
 	 * This frame is eligible for an AMPDU, however, don't aggregate
 	 * frames that are intended to probe a specific tx rate.
-- 
1.7.2.3

