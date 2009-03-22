Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZCVJkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 05:40:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1LlKA1-00078c-08
	for linux-wireless@vger.kernel.org; Sun, 22 Mar 2009 10:40:05 +0100
Subject: [RFC] staging wireless crap: tell people not to work on it
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 10:40:03 +0100
Message-Id: <1237714803.5100.770.camel@johannes.local> (sfid-20090322_104019_209592_D82B3C2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any objections from anyone on this? We've had somebody clean out otus
because he thought it was a good idea...

johannes
---
 drivers/staging/at76_usb/TODO  |    4 ++--
 drivers/staging/otus/TODO      |    7 +++----
 drivers/staging/rt2860/TODO    |    4 ++--
 drivers/staging/rt2870/TODO    |    9 ++++++++-
 drivers/staging/wlan-ng/README |    4 +++-
 5 files changed, 18 insertions(+), 10 deletions(-)

--- wireless-testing.orig/drivers/staging/at76_usb/TODO	2009-03-22 10:31:37.000000000 +0100
+++ wireless-testing/drivers/staging/at76_usb/TODO	2009-03-22 10:31:37.000000000 +0100
@@ -1,2 +1,2 @@
-rewrite the driver to use the proper in-kernel wireless stack
-instead of using its own.
+Work on at76c50x-usb instead, possibly using
+this driver as a reference.
--- wireless-testing.orig/drivers/staging/otus/TODO	2009-03-22 10:31:36.000000000 +0100
+++ wireless-testing/drivers/staging/otus/TODO	2009-03-22 10:31:37.000000000 +0100
@@ -1,8 +1,7 @@
 TODO:
-	- checkpatch.pl cleanups
-	- sparse cleanups
-	- port to in-kernel 80211 stack
-	- proper network developer maintainer
+	Any functionality in this driver should be integrated
+	into the ar9170 driver that is under development on the
+	linux-wireless mailing list.
 
 Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
 Luis Rodriguez <Luis.Rodriguez@Atheros.com> and the
--- wireless-testing.orig/drivers/staging/rt2860/TODO	2009-03-22 10:31:43.000000000 +0100
+++ wireless-testing/drivers/staging/rt2860/TODO	2009-03-22 10:34:12.000000000 +0100
@@ -1,6 +1,6 @@
 I'm hesitant to add a TODO file here, as the wireless developers would
 really have people help them out on the "clean" rt2860 driver that can
-be found at the rt2860.sf.net site.
+be found at the http://rt2x00.serialmonkey.com/ site.
 
 But, if you wish to clean up this driver instead, here's a short list of
 things that need to be done to get it into a more mergable shape:
@@ -8,7 +8,7 @@ things that need to be done to get it in
 TODO:
 	- checkpatch.pl clean
 	- sparse clean
-	- port to in-kernel 80211 stack
+	- port to in-kernel 80211 stack and common rt2x00 infrastructure
 	- remove reading from /etc/ config files
 	- review by the wireless developer community
 
--- wireless-testing.orig/drivers/staging/rt2870/TODO	2009-03-22 10:31:57.000000000 +0100
+++ wireless-testing/drivers/staging/rt2870/TODO	2009-03-22 10:34:04.000000000 +0100
@@ -1,7 +1,14 @@
+I'm hesitant to add a TODO file here, as the wireless developers would
+really have people help them out on the "clean" rt2870 driver that can
+be found at the http://rt2x00.serialmonkey.com/ site.
+
+But, if you wish to clean up this driver instead, here's a short list of
+things that need to be done to get it into a more mergable shape:
+
 TODO:
 	- checkpatch.pl clean
 	- sparse clean
-	- port to in-kernel 80211 stack
+	- port to in-kernel 80211 stack and common rt2x00 infrastructure
 	- remove reading from /etc/ config files
 	- review by the wireless developer community
 
--- wireless-testing.orig/drivers/staging/wlan-ng/README	2009-03-22 10:34:25.000000000 +0100
+++ wireless-testing/drivers/staging/wlan-ng/README	2009-03-22 10:34:32.000000000 +0100
@@ -4,4 +4,6 @@ TODO:
 	- Lindent cleanups
 	- move to use the in-kernel wireless stack
 
-Please send all patches to Greg Kroah-Hartman <greg@kroah.com>
+Please send any patches or complaints about this driver to Greg
+Kroah-Hartman <greg@kroah.com> and don't bother the upstream wireless
+kernel developers about it, they want nothing to do with it.


