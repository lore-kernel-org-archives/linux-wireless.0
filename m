Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54225 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaAXWrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:47:24 -0500
Received: by mail-pd0-f178.google.com with SMTP id y13so3634459pdi.9
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:47:24 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 10/11] rel-html: update CRDA project file
Date: Fri, 24 Jan 2014 14:46:32 -0800
Message-Id: <1390603593-27728-11-git-send-email-mcgrof@do-not-panic.com> (sfid-20140125_000006_069830_7ECF63CA)
In-Reply-To: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
References: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CRDA is now licensed under the copyleft-next project.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 projects/crda.cfg | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/projects/crda.cfg b/projects/crda.cfg
index c52bb6b..33c2c66 100644
--- a/projects/crda.cfg
+++ b/projects/crda.cfg
@@ -1,9 +1,10 @@
 [project]
 rel_html_proj           = crda
 supported =
-	1.1
+	3.13
+	3.14
 rel_html_url_releases	= http://kernel.org/pub/software/network/crda/
-rel_license 		= ISC
+rel_license 		= copyleft-next
 ignore_changelogs	= True
 
 [html]
-- 
1.8.5.2

