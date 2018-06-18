Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58152 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933834AbeFRUo0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 16:44:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] rfkill: add header files to MAINTAINERS
Date: Mon, 18 Jun 2018 22:44:23 +0200
Message-Id: <20180618204423.29746-1-johannes@sipsolutions.net> (sfid-20180618_224431_848245_CF1D58DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These files weren't covered by the MAINTAINERS file,
add them.

Reported-by: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2c7069037a15..1fe2aac28177 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12155,6 +12155,8 @@ S:	Maintained
 F:	Documentation/rfkill.txt
 F:	Documentation/ABI/stable/sysfs-class-rfkill
 F:	net/rfkill/
+F:	include/linux/rfkill.h
+F:	include/uapi/linux/rfkill.h
 
 RHASHTABLE
 M:	Thomas Graf <tgraf@suug.ch>
-- 
2.14.4
