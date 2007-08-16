Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51504 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbXHPQld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 12:41:33 -0400
Subject: [PATCH] mark islsm list as subscribers-only
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 18:44:13 +0200
Message-Id: <1187282653.23489.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is bordering on stupid. I just received a bounce from it because
I'm not subscribed:

---begin mail---
Sorry, this list is for subscribers only. We previously held incoming
mail by non-subscribers for manual approval, but due to the increase
in spam this is no longer feasible.

If you are seriously attempting to send mail to the islsm developers
list, please subscribe to the list and re-send.
---end mail---

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Or just remove it from MAINTAINERS as it obviously doesn't want mail.

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/MAINTAINERS	2007-08-16 18:38:11.713468950 +0200
+++ wireless-dev/MAINTAINERS	2007-08-16 18:42:49.783468950 +0200
@@ -3037,7 +3037,7 @@ P54 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
-L:	developers@islsm.org
+L:	developers@islsm.org (subscribers-only; drops mail but spams you)
 W:	http://prism54.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained


