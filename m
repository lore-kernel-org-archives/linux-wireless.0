Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51928 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAXWrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:47:08 -0500
Received: by mail-pa0-f50.google.com with SMTP id kp14so3789096pab.9
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:47:07 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 06/11] rel-html: add the 2014 URL backports snapshot releases
Date: Fri, 24 Jan 2014 14:46:28 -0800
Message-Id: <1390603593-27728-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20140124_234711_888732_1B34E6B1)
In-Reply-To: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
References: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 projects/backports.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/projects/backports.cfg b/projects/backports.cfg
index ae9cdac..eed900a 100644
--- a/projects/backports.cfg
+++ b/projects/backports.cfg
@@ -13,6 +13,7 @@ eol =
 	3.7
 rel_html_url_releases	= http://www.kernel.org/pub/linux/kernel/projects/backports/stable/
 			  http://www.kernel.org/pub/linux/kernel/projects/backports/2013/
+			  http://www.kernel.org/pub/linux/kernel/projects/backports/2014/
 rel_license 		= GPLv2
 ignore_changelogs	= True
 
-- 
1.8.5.2

