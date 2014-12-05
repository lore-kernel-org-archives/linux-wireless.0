Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:61570 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaLETmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 14:42:55 -0500
Received: by mail-oi0-f49.google.com with SMTP id i138so938053oig.22
        for <linux-wireless@vger.kernel.org>; Fri, 05 Dec 2014 11:42:54 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: Update location of wireless-regdb repository
Date: Fri,  5 Dec 2014 13:42:32 -0600
Message-Id: <1417808552-56153-1-git-send-email-seth.forshee@canonical.com> (sfid-20141205_204258_254869_FE3EED69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've taken over maintenance of the wireless regulatory database
from linville. Update references to John's repository to point
at my repository instead.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Documentation/networking/regulatory.txt | 2 +-
 net/wireless/db.txt                     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/regulatory.txt b/Documentation/networking/regulatory.txt
index 356f791af574..b4af93fbbff6 100644
--- a/Documentation/networking/regulatory.txt
+++ b/Documentation/networking/regulatory.txt
@@ -205,7 +205,7 @@ the data in regdb.c as an alternative to using CRDA.
 The file net/wireless/db.txt should be kept up-to-date with the db.txt
 file available in the git repository here:
 
-    git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
+    git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git
 
 Again, most users in most situations should be using the CRDA package
 provided with their distribution, and in most other situations users
diff --git a/net/wireless/db.txt b/net/wireless/db.txt
index a2fc3a09ccdc..4f7715d87979 100644
--- a/net/wireless/db.txt
+++ b/net/wireless/db.txt
@@ -13,5 +13,5 @@
 # best option is to extract the db.txt file from the wireless-regdb git
 # repository:
 #
-#   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
+#   git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git
 #
-- 
1.9.1

