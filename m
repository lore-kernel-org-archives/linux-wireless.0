Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbYBYPcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:32:16 -0500
Message-Id: <20080225152740.360393000@sipsolutions.net> (sfid-20080225_153223_893460_C5333C8A)
Date: Mon, 25 Feb 2008 16:27:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 00/10] mac80211 locking/sta info work
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches contains my current sta_info and
mac80211 locking work, the sta info patches are now based
on top of the mesh networking.

Luis, please verify that I didn't break mesh networking,
I cannot currently test it. Also, I think I got the lifetime
rules for mesh peer links correct, but it could use a check.

Still, I think it should be merged and we can fix any more
problems, it's rather intrusive and clashes with most other
work.

Tested in both AP and STA mode and working fine.

johannes

