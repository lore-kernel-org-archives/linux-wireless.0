Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2877 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0APTh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 14:37:26 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/2] PID controller fixes
Date: Sat, 16 Jan 2010 14:36:51 -0500
Message-Id: <1263670613-10864-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are two fixes to the PID rc.  The first one improves PID
performance by quite a bit on my test setup, and seems correct,
but I am not an expert on the algo so comments welcome.  The
other is just a minor cleanup.  With the change, Minstrel is
still a bit better in my tests.

Bob Copeland (2):
  mac80211: fix sign error in pid controller
  mac80211: pid: replace open-coded msecs_to_jiffies

 net/mac80211/rc80211_pid_algo.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)


