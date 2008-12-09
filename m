Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:11104 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbYLIRcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 12:32:17 -0500
Subject: [PATCH] airport: remove useless return in a function returning void
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 09 Dec 2008 12:32:15 -0500
Message-ID: <20081209173214.16159.68925.stgit@dv.roinet.com> (sfid-20081209_183220_038188_3A3BB3B3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/orinoco/airport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index ce03a2e..28f1cae 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -279,7 +279,7 @@ init_airport(void)
 static void __exit
 exit_airport(void)
 {
-	return macio_unregister_driver(&airport_driver);
+	macio_unregister_driver(&airport_driver);
 }
 
 module_init(init_airport);
