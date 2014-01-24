Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41545 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAXWq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:46:58 -0500
Received: by mail-pa0-f42.google.com with SMTP id kl14so3777302pab.29
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:46:58 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 04/11] rel-html: add 3.14 for backports project release file
Date: Fri, 24 Jan 2014 14:46:26 -0800
Message-Id: <1390603593-27728-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20140124_234701_907345_D895663D)
In-Reply-To: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
References: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is in preparation for the 3.14-rc1 release.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 projects/backports.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/projects/backports.cfg b/projects/backports.cfg
index 2ea2ca3..ae9cdac 100644
--- a/projects/backports.cfg
+++ b/projects/backports.cfg
@@ -2,6 +2,7 @@
 rel_html_proj		= backports
 rel_html_proj_aliases	= compat-drivers
 supported =
+	3.14
 	3.13
 	3.12
 	3.11
-- 
1.8.5.2

