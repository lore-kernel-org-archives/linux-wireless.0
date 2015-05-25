Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:32939 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbbEYRzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 13:55:55 -0400
From: Shailendra Verma <shailendra.capricorn@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Shailendra Verma <shailendra.capricorn@gmail.com>
Subject: [PATCH] net:wireless - Change 1 to true for bool type variable.
Date: Mon, 25 May 2015 23:25:44 +0530
Message-Id: <1432576544-3639-1-git-send-email-shailendra.capricorn@gmail.com> (sfid-20150525_195619_621717_47A30C1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable translate is bool type.So assigning true instead of 1.

Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
---
 drivers/net/wireless/ray_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 477f863..0881ba8 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -143,7 +143,7 @@ static int psm;
 static char *essid;
 
 /* Default to encapsulation unless translation requested */
-static bool translate = 1;
+static bool translate = true;
 
 static int country = USA;
 
-- 
1.7.9.5

