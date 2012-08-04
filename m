Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2HDDKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 23:10:04 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.80)
	(envelope-from <wireless@sipsolutions.net>)
	id 1SxUkd-0007vk-3c
	for linux-wireless@vger.kernel.org; Sat, 04 Aug 2012 05:10:03 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v3.6
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1SxUkd-0007vk-3c@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Sat, 04 Aug 2012 05:10:03 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v3.6) is available at:

http://wireless.kernel.org/download/iw/iw-3.6.tar.bz2

SHA1 sum: e3e0600ced24c05e84ba021c2629bf9dcafd5c3b

Here is the short log of the changes (since v3.5)
included in this release:

Chun-Yeow Yeoh (1):
      iw: allow setting mesh proactive tree building mode related parameters

Johannes Berg (10):
      add (optional) hwsim code
      update nl80211.h
      update nl80211.h
      update nl80211.h
      add basics for identify wireless devs
      update interface info for non-netdev wdevs
      pass idby argument to all functions
      allow wdev in place of dev
      print wdev id in event info
      update version to 3.6

Vladimir Kondratiev (3):
      Prefer 32-bit bitrate
      introduce GCMP cipher
      Fix print channel number for 60g

