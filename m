Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46832 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaAXWrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:47:16 -0500
Received: by mail-pd0-f178.google.com with SMTP id y13so3627978pdi.37
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:47:15 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 08/11] rel-html: add copyleft-next URL reference
Date: Fri, 24 Jan 2014 14:46:30 -0800
Message-Id: <1390603593-27728-9-git-send-email-mcgrof@do-not-panic.com> (sfid-20140124_234719_818973_2640C5A8)
In-Reply-To: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
References: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets us allow projects to specify the copyleft-next
license and point to the license's home page. As per Richard
this license is definitely ready to be used by projects.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 rel-html.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rel-html.py b/rel-html.py
index 95d4877..0a48ea0 100755
--- a/rel-html.py
+++ b/rel-html.py
@@ -1082,6 +1082,8 @@ def license_url(license):
         return "http://opensource.org/licenses/ISC"
     elif (license == 'AGPL'):
         return "http://www.gnu.org/licenses/agpl-3.0.html"
+    elif (license == 'copyleft-next'):
+        return "http://copyleft-next.org/"
     else:
         return "http://opensource.org/licenses/alphabetical"
 
-- 
1.8.5.2

