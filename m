Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52850 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaFNNtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:49:24 -0400
Received: by mail-pd0-f170.google.com with SMTP id z10so1537979pdj.29
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:49:24 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id x5sm9007808pbw.26.2014.06.14.06.49.22
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:49:23 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/16] rsi: Fixed the kernel doc
Date: Sat, 14 Jun 2014 19:19:14 +0530
Message-Id: <1402753754-13887-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_154927_847077_FC58BD42)
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

