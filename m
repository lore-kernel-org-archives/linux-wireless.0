Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:2976 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbZF3VTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:19:17 -0400
Subject: [PATCH 3/5] Have the 'clean' target announce its presence.
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 16:19:21 -0500
Message-Id: <1246396761.13176.263.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just like the other build and install targets, have the
clean target announce "CLEAN" too.

Signed-off-by: Jon Loeliger <jdl@bigfootnetworks.com>
---
 Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 8dbdf14..776b259 100644
--- a/Makefile
+++ b/Makefile
@@ -149,5 +149,6 @@ install_man: $(INSTALL_MAN)
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ regdbdump.8.gz
 
 clean:
+	$(NQ) '    CLEAN'
 	$(Q)rm -f crda regdbdump intersect *.o *~ *.pyc keys-*.c *.gz \
 	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
-- 
1.6.3.GIT



