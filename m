Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37834 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaAXWrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:47:20 -0500
Received: by mail-pa0-f47.google.com with SMTP id kp14so3767572pab.34
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:47:20 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 09/11] rel-html: add 3.14 release to iw project
Date: Fri, 24 Jan 2014 14:46:31 -0800
Message-Id: <1390603593-27728-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20140124_234723_555000_B30E7A4B)
In-Reply-To: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
References: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prepares rel-html to make 3.14 based releases, which
are not yet released.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 projects/iw.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/projects/iw.cfg b/projects/iw.cfg
index c019bca..23f2944 100644
--- a/projects/iw.cfg
+++ b/projects/iw.cfg
@@ -6,6 +6,7 @@ supported =
 	3.11
 	3.12
 	3.13
+	3.14
 rel_html_testing_ver	= latest
 rel_html_url_releases	= https://www.kernel.org/pub/software/network/iw/
 rel_license 		= ISC
-- 
1.8.5.2

