Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:39426 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206AbZLDRFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 12:05:02 -0500
Date: Fri, 04 Dec 2009 17:04:39 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [rfkill PATCH] Move the man page to section 8
Message-ID: <50C9E517AC%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 Makefile             |    8 ++++----
 rfkill.1 => rfkill.8 |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)
 rename rfkill.1 => rfkill.8 (97%)

diff --git a/Makefile b/Makefile
index 71a6082..2c5fd9e 100644
--- a/Makefile
+++ b/Makefile
@@ -46,13 +46,13 @@ check:
 	@$(NQ) ' GZIP' $<
 	$(Q)gzip < $< > $@
 
-install: rfkill rfkill.1.gz
+install: rfkill rfkill.8.gz
 	@$(NQ) ' INST rfkill'
 	$(Q)$(MKDIR) $(DESTDIR)$(SBINDIR)
 	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)$(SBINDIR) rfkill
-	@$(NQ) ' INST rfkill.1'
-	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man1/
-	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)$(MANDIR)/man1/ rfkill.1.gz
+	@$(NQ) ' INST rfkill.8'
+	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man8/
+	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)$(MANDIR)/man8/ rfkill.8.gz
 
 clean:
 	$(Q)rm -f rfkill *.o *~ *.gz version.c *-stamp
diff --git a/rfkill.1 b/rfkill.8
similarity index 97%
rename from rfkill.1
rename to rfkill.8
index fc55be0..da06b27 100644
--- a/rfkill.1
+++ b/rfkill.8
@@ -1,5 +1,5 @@
 .\"                                      Hey, EMACS: -*- nroff -*-
-.TH RFKILL 1 "July 10, 2009"
+.TH RFKILL 8 "July 10, 2009"
 .SH NAME
 rfkill \- tool for enabling and disabling wireless devices
 .SH SYNOPSIS
-- 
1.6.5

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + http://wiki.debian.org/DebianEeePC/

Tallulah Bankhead barged down the Nile last night as Cleopatra and sank.
