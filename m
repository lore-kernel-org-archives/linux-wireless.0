Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1027 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbZKLWyz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 17:54:55 -0500
Subject: [PATCH] MAINTAINERS: RFKILL - Fix pattern entry missing colon
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 14:55:00 -0800
Message-ID: <1258066500.9696.7.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8264e6b..78c5a25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4417,7 +4417,7 @@ RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-F	Documentation/rfkill.txt
+F:	Documentation/rfkill.txt
 F:	net/rfkill/
 
 RISCOM8 DRIVER


