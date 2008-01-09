Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:18537 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752438AbYAIJQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 04:16:11 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: ath5k: beacon patches
Date: Wed,  9 Jan 2008 18:16:03 +0900
Message-Id: <1199870169-10476-1-git-send-email-bruno@thinktube.com> (sfid-20080109_091621_414748_915EACE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello!

here are some smaller, mostly cosmetic clean-up patches for ath5k concerning
beacons.  i came across these things while trying to make beaconing work for
IBSS mode.  right now (after patch 0005 specifically) beacons are sent, but
there is no backoff between the IBSS stations. for that to work we need more
info from mac80211, especially the timestamp of the last received beacon.  i'll
try to look into that next.

bruno


