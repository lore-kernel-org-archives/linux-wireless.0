Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36003 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761008AbZC0VVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:21:07 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: Update maintainers for ath9k
Date: Fri, 27 Mar 2009 17:21:05 -0400
Message-Id: <1238188865-10420-1-git-send-email-lrodriguez@atheros.com> (sfid-20090327_222122_946851_519535AA)
To: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has been the case really, we just forgot to update it.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

John, please Cc Sujith, Vasanth, and Senthil on kernel.org bug
reports as well. I won't have a chance to monitor those as
closely as I have now, will be switching gears to focus on
our next Atheros 11N USB chipset (which BTW will use a different
MAC than ar9170).

 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a6e9e9..2d8bdde 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -761,6 +761,12 @@ P:	Luis R. Rodriguez
 M:	lrodriguez@atheros.com
 P:	Jouni Malinen
 M:	jmalinen@atheros.com
+P:	Sujith Manoharan
+M:	Sujith.Manoharan@atheros.com
+P:	Vasanthakumar Thiagarajan
+M:	vasanth@atheros.com
+P:	Senthil Balasubramanian
+M:	senthilkumar@atheros.com
 L:	linux-wireless@vger.kernel.org
 L:	ath9k-devel@lists.ath9k.org
 S:	Supported
-- 
1.6.2.1.316.gedbc2

