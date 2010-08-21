Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44296 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0HUK4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 06:56:02 -0400
Received: by wyb32 with SMTP id 32so4726290wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Aug 2010 03:56:01 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: David Kilroy <kilroyd@googlemail.com>,
	Pavel Roskin <proski@gnu.org>,
	David Gibson <hermes@gibson.dropbear.id.au>
Subject: [PATCH] orinoco: update status in MAINTAINERS
Date: Sat, 21 Aug 2010 12:13:45 +0100
Message-Id: <1282389225-30154-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
---
I believe this has been the state for a while...

 MAINTAINERS |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b5b8baa..9534a87 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4297,13 +4297,12 @@ F:	Documentation/filesystems/dlmfs.txt
 F:	fs/ocfs2/
 
 ORINOCO DRIVER
-M:	Pavel Roskin <proski@gnu.org>
-M:	David Gibson <hermes@gibson.dropbear.id.au>
 L:	linux-wireless@vger.kernel.org
 L:	orinoco-users@lists.sourceforge.net
 L:	orinoco-devel@lists.sourceforge.net
+W:	http://linuxwireless.org/en/users/Drivers/orinoco
 W:	http://www.nongnu.org/orinoco/
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/orinoco/
 
 OSD LIBRARY and FILESYSTEM
-- 
1.7.1

