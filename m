Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:42880 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423331AbeCBNn1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 08:43:27 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc: Samuel Chessman <chessman@tux.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial resend^2] net: Spelling s/stucture/structure/
Date: Fri,  2 Mar 2018 14:43:23 +0100
Message-Id: <1519998203-13020-1-git-send-email-geert+renesas@glider.be> (sfid-20180302_144348_982626_619031DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/ti/tlan.c     | 2 +-
 drivers/net/wireless/atmel/atmel.c | 2 +-
 include/net/iw_handler.h           | 2 +-
 net/socket.c                       | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 5a4e78fde530ad4a..c769cd9d11e74948 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -1901,7 +1901,7 @@ ThunderLAN driver adapter related routines
  *		Nothing
  *	Parms:
  *		dev	The device structure with the list
- *			stuctures to be reset.
+ *			structures to be reset.
  *
  *	This routine sets the variables associated with managing
  *	the TLAN lists to their initial values.
diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index c9dd5e44c9c6de6d..d122386c382bcef2 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -3861,7 +3861,7 @@ static int reset_atmel_card(struct net_device *dev)
 
 	   set all the Mib values which matter in the card to match
 	   their settings in the atmel_private structure. Some of these
-	   can be altered on the fly, but many (WEP, infrastucture or ad-hoc)
+	   can be altered on the fly, but many (WEP, infrastructure or ad-hoc)
 	   can only be changed by tearing down the world and coming back through
 	   here.
 
diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index 725282095840b853..d2ea5863eedca5ce 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -364,7 +364,7 @@ struct iw_handler_def {
  * defined in struct iw_priv_args.
  *
  * For standard IOCTLs, things are quite different and we need to
- * use the stuctures below. Actually, this struct is also more
+ * use the structures below. Actually, this struct is also more
  * efficient, but that's another story...
  */
 
diff --git a/net/socket.c b/net/socket.c
index 645d32b4872cb5d8..63e0a6e17cc54e58 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1516,7 +1516,7 @@ SYSCALL_DEFINE2(listen, int, fd, int, backlog)
  *
  *	1003.1g adds the ability to recvmsg() to query connection pending
  *	status to recvmsg. We need to add that support in a way thats
- *	clean when we restucture accept also.
+ *	clean when we restructure accept also.
  */
 
 SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
-- 
2.7.4
