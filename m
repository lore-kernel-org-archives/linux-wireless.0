Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37520
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbXIYUmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 16:42:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>
Subject: zd1211 or mac80211: SKB invalid truesize
Date: Tue, 25 Sep 2007 22:42:11 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709252242.12331.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get dmesg spammed with the following message when
I connect to an open network with zd1211rw-mac80211.
I'm not sure if that's a bug in zd or mac80211.
Any idea how to debug this?

[  280.915811] SKB BUG: Invalid truesize (840) len=1440, sizeof(sk_buff)=168

The device keeps working fine while this spams dmesg.
