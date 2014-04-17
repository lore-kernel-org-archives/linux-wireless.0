Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53851 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaDQWxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 18:53:00 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] rel-html add v3.15 and hostapd-2.1 to list of supported projects
Date: Thu, 17 Apr 2014 15:52:51 -0700
Message-Id: <1397775171-3698-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140418_005317_933502_9A0109A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quite a few software projects rel-html supports relies on
the kernel release numbers, so we update those to match the
latest kernel. The Linux kernel now dropped quite a few EOL
kernels, and hostapd gets a new hostapd-2.1 release.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 projects/backports.cfg | 1 +
 projects/crda.cfg      | 1 +
 projects/hostapd.cfg   | 1 +
 projects/iw.cfg        | 1 +
 rel-html.cfg           | 5 +----
 5 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/projects/backports.cfg b/projects/backports.cfg
index eed900a..afe52e9 100644
--- a/projects/backports.cfg
+++ b/projects/backports.cfg
@@ -2,6 +2,7 @@
 rel_html_proj		= backports
 rel_html_proj_aliases	= compat-drivers
 supported =
+	3.15
 	3.14
 	3.13
 	3.12
diff --git a/projects/crda.cfg b/projects/crda.cfg
index 33c2c66..116de9b 100644
--- a/projects/crda.cfg
+++ b/projects/crda.cfg
@@ -3,6 +3,7 @@ rel_html_proj           = crda
 supported =
 	3.13
 	3.14
+	3.15
 rel_html_url_releases	= http://kernel.org/pub/software/network/crda/
 rel_license 		= copyleft-next
 ignore_changelogs	= True
diff --git a/projects/hostapd.cfg b/projects/hostapd.cfg
index c2f0c68..0e1841e 100644
--- a/projects/hostapd.cfg
+++ b/projects/hostapd.cfg
@@ -3,6 +3,7 @@ rel_html_proj           = hostapd
 supported =
 	1.1
 	2.0
+	2.1
 rel_html_url_releases	= http://hostap.epitest.fi/releases/
 rel_license 		= BSD
 ignore_signatures	= True
diff --git a/projects/iw.cfg b/projects/iw.cfg
index 23f2944..85713d6 100644
--- a/projects/iw.cfg
+++ b/projects/iw.cfg
@@ -7,6 +7,7 @@ supported =
 	3.12
 	3.13
 	3.14
+	3.15
 rel_html_testing_ver	= latest
 rel_html_url_releases	= https://www.kernel.org/pub/software/network/iw/
 rel_license 		= ISC
diff --git a/rel-html.cfg b/rel-html.cfg
index a4baa15..4213798 100644
--- a/rel-html.cfg
+++ b/rel-html.cfg
@@ -1,17 +1,14 @@
 [project]
 rel_html_proj           = linux
 supported =
+		3.15
 		3.14
 		3.13
 		3.12
 		3.10
 		3.4
 		3.2
-		2.6.34
 		2.6.32
-eol =
-		3.11
-		3.0
 rel_html_url_releases	= http://www.kernel.org/pub/linux/kernel/v3.0/testing
 			  http://www.kernel.org/pub/linux/kernel/v3.0
 			  http://www.kernel.org/pub/linux/kernel/v2.6
-- 
1.9.1

