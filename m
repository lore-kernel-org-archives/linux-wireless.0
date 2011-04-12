Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab1DLJv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 05:51:58 -0400
Subject: [PATCH] regdb: fix moinmoin plugin license
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 11:51:49 +0200
Message-ID: <1302601909.3639.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Hutchings told me that Debian found that the license statements
don't match, it says GPL but the top-level LICENSE file is ISC. It
doesn't really matter to me, so change the license here to ISC.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---

--- a/web/Regulatory.py
+++ b/web/Regulatory.py
@@ -3,7 +3,7 @@
     Regulatory Database
 
     @copyright: 2008 Johannes Berg
-    @license: GNU GPL, see COPYING for details.
+    @license: ISC, see LICENSE for details.
 """
 
 import codecs, math


