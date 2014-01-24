Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63779 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaAXWqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:46:54 -0500
Received: by mail-pb0-f53.google.com with SMTP id md12so3731787pbc.26
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:46:54 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 03/11] rel-html: update Linux project file
Date: Fri, 24 Jan 2014 14:46:25 -0800
Message-Id: <1390603593-27728-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20140124_234657_575276_C6AE302F)
In-Reply-To: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
References: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reflects the latest changes for kernel release
project maintenance. The 3.14-rc1 is not out yet but
should be out soon.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 rel-html.cfg | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/rel-html.cfg b/rel-html.cfg
index d6b010e..a4baa15 100644
--- a/rel-html.cfg
+++ b/rel-html.cfg
@@ -1,9 +1,10 @@
 [project]
 rel_html_proj           = linux
 supported =
+		3.14
 		3.13
 		3.12
-		3.12
+		3.10
 		3.4
 		3.2
 		2.6.34
-- 
1.8.5.2

