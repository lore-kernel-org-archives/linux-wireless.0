Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34779 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdABH2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 02:28:42 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 1/2] cfg80211: update wireless-regdb repo url in Documentation
Date: Mon,  2 Jan 2017 08:28:28 +0100
Message-Id: <20170102072829.9766-1-zajec5@gmail.com> (sfid-20170102_082850_118021_34FE25DA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

It's maintained by Seth Forshe for a long time now.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Cc: Seth Forshee <seth.forshee@canonical.com>
---
 Documentation/networking/regulatory.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/regulatory.txt b/Documentation/networking/regulatory.txt
index 356f791..b4af93f 100644
--- a/Documentation/networking/regulatory.txt
+++ b/Documentation/networking/regulatory.txt
@@ -205,7 +205,7 @@ the data in regdb.c as an alternative to using CRDA.
 The file net/wireless/db.txt should be kept up-to-date with the db.txt
 file available in the git repository here:
 
-    git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
+    git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git
 
 Again, most users in most situations should be using the CRDA package
 provided with their distribution, and in most other situations users
-- 
2.10.1
