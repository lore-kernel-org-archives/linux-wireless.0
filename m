Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56052 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbZG0XKY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 19:10:24 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 16:10:25 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] wext: remove extra return on wireless_nlevent_init()
Date: Mon, 27 Jul 2009 16:10:22 -0700
Message-ID: <1248736222-27280-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/wext.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/wireless/wext.c b/net/wireless/wext.c
index 3fe3c2c..5b4a0ce 100644
--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -1291,7 +1291,6 @@ static struct pernet_operations wext_pernet_ops = {
 static int __init wireless_nlevent_init(void)
 {
 	return register_pernet_subsys(&wext_pernet_ops);
-	return 0;
 }
 
 subsys_initcall(wireless_nlevent_init);
-- 
1.6.3.3

