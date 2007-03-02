Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:51638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965638AbXCBVQK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 16:16:10 -0500
Subject: patch driver-core-export-device_rename.patch added to gregkh-2.6 tree
To: johannes@sipsolutions.net, greg@kroah.com, gregkh@suse.de,
	linux-wireless@vger.kernel.org
From: <gregkh@suse.de>
Date: Fri, 02 Mar 2007 13:15:06 -0800
In-Reply-To: <1172662711.3681.51.camel@johannes.berg>
Message-Id: <20070302211555.B25A9C52049@imap.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

     Subject: driver core: export device_rename

to my gregkh-2.6 tree.  Its filename is

     driver-core-export-device_rename.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From johannes@sipsolutions.net Wed Feb 28 03:38:54 2007
From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 28 Feb 2007 12:38:31 +0100
Subject: driver core: export device_rename
To: Greg KH <greg@kroah.com>, linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <1172662711.3681.51.camel@johannes.berg>


In wireless we'd like to allow renaming of the phy devices we surface in
sysfs. The base wireless code, however, can be built modular and thus we
need device_rename exported.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- gregkh-2.6.orig/drivers/base/core.c
+++ gregkh-2.6/drivers/base/core.c
@@ -1056,7 +1056,7 @@ int device_rename(struct device *dev, ch
 
 	return error;
 }
-
+EXPORT_SYMBOL_GPL(device_rename);
 
 static int device_move_class_links(struct device *dev,
 				   struct device *old_parent,


Patches currently in gregkh-2.6 which might be from johannes@sipsolutions.net are

-
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


!DSPAM:45e8931523627818312239!
