Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39597 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762019Ab3ECL33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 07:29:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UYEB6-0001jM-1d
	for linux-wireless@vger.kernel.org; Fri, 03 May 2013 13:29:28 +0200
Message-ID: <1367580565.13104.8.camel@jlt4.sipsolutions.net> (sfid-20130503_132950_657767_A891FF55)
Subject: [ANN] iw version 3.10
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 03 May 2013 13:29:25 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since I'd clearly forgotten to release iw version 3.9, I skipped right
to 3.10 since the merge window for the kernel is open and features are
final.

Here's the shortlog:

Amitkumar Karwar (1):
      iw: add packet offset information for wowlan pattern

Ben Greear (2):
      iw: Print beacon-loss-event string.
      iw/event: Print out PROBE_CLIENT event information.

Joerg Mayer (1):
      iw: decode some more IEs

Johannes Berg (19):
      fix PMKSA event
      add "auth" command
      update nl80211.h
      update nl80211.h
      support TCP wakeup API
      override default buffer size
      fix TCP wowlan bug
      update nl80211.h
      iw: support split wiphy dump
      refactor bitrate printing
      align TDLS output
      fix scan segfault when IFINDEX attribute isn't present
      clean up makefile
      makefile: don't include .config
      makefile: allow passing NO_PKG_CONFIG
      add Android build system
      fix "iw phy#0 info"
      update nl80211 to 3.10 version
      update version to 3.10

Marco Porsch (3):
      iw: add beacon interval and DTIM period parameters to mesh join
      iw: add default mesh Power Mode and Awake Window to mesh config
      iw: add support for link-specific mesh power modes

Simon Wunderlich (2):
      iw: add radar detect widths to phy info
      iw: print DFS states for channels if available

Vladimir Kondratiev (1):
      iw: print capability info for DMG (60GHz band)

Yogesh Ashok Powar (1):
      iw: Add VHT info in link query

Zefir Kurtisi (2):
      iw: don't print DFS states of disabled frequencies
      iw: display DFS regulatory domain


johannes

