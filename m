Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g19.free.fr ([212.27.42.27]:55216 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYAQMMo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 07:12:44 -0500
Date: Thu, 17 Jan 2008 13:12:41 +0100 (CET)
From: Marc.Herbert@gmail.com
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
cc: linux-wireless@vger.kernel.org
Subject: no attachment [PATCH] compat-2.6: fix "make unload" / ieee80211_crypt_tkip
Message-ID: <Pine.LNX.4.64.0801171306110.22400@maradi> (sfid-20080117_121249_927232_5FCCB8F8)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-sent without an "octet-stream" attachment, sorry. (gmail sucks)

     -----------

Hi there,

I need this one-line patch for "make unload" to work on my Ubuntu 
gutsy.

The actual reason is beyond me, but I'm sure one of you will figure it
out and fix my fix in case it's not "the right thing".

Cheers,

Marc.


--- scripts/unload.sh	2008/01/17 09:59:28	1.1
+++ scripts/unload.sh	2008/01/17 10:00:24
@@ -6,6 +6,7 @@
  MODULES="$OLD_MODULES"
  MODULES="$MODULES ipw2100 ipw2200"
  MODULES="$MODULES libertas_cs usb8xxx libertas"
+MODULES="$MODULES ieee80211_crypt_tkip ieee80211_crypt_ccmp"
  MODULES="$MODULES ieee80211softmac ieee80211_crypt ieee80211"
  MODULES="$MODULES adm8211"
  MODULES="$MODULES b43 b43legacy"
