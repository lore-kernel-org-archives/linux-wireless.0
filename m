Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33651 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFPOKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:10:13 -0400
Received: by mail-pb0-f44.google.com with SMTP id md12so3707041pbc.3
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 07:10:13 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id gu1sm19042462pbd.0.2014.06.16.07.10.11
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 16 Jun 2014 07:10:12 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 02/16] rsi: Fixed the kernel doc
Date: Mon, 16 Jun 2014 19:40:02 +0530
Message-Id: <1402927802-3793-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140616_161035_781678_53D6E966)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed the function header to match the function name.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 54aaeb0..a1bdea1 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -185,7 +185,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 }
 
 /**
- * rsi_mac80211_attach() - This function is used to de-initialize the
+ * rsi_mac80211_detach() - This function is used to de-initialize the
  *			   Mac80211 stack.
  * @adapter: Pointer to the adapter structure.
  *
-- 
1.7.1

