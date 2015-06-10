Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbbFJOaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 10:30:14 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com,
	Luis Correia <luis.f.correia@gmail.com>
Subject: [PATCH] rt2x00, MAINTAINERS: remove rt2x00.serialmonkey.com list and web page
Date: Wed, 10 Jun 2015 16:30:05 +0200
Message-Id: <1433946605-11515-1-git-send-email-sgruszka@redhat.com> (sfid-20150610_163018_076050_56B605B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00.serialmonkey.com will be shutdown.

Since traffic on rt2x00 mailing list is very low, we can use only
linux-wireless list for any rt2x00 related topics.

Thanks for Luis Correia, Ivo van Doorn and Mark Wallis for maintaining
rt2x00 servers for years!

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f8e0afb..03a3512 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8144,8 +8144,6 @@ P:	rt2x00 project
 M:	Stanislaw Gruszka <sgruszka@redhat.com>
 M:	Helmut Schaa <helmut.schaa@googlemail.com>
 L:	linux-wireless@vger.kernel.org
-L:	users@rt2x00.serialmonkey.com (moderated for non-subscribers)
-W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
 F:	drivers/net/wireless/rt2x00/
 
-- 
1.8.3.1

