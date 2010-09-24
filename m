Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0IXJXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 05:23:44 -0400
Message-Id: <20100924092104.384954781@sipsolutions.net>
Date: Fri, 24 Sep 2010 11:21:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>
Subject: [PATCH 0/5] mac80211 cleanups & fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a set of mac80211 patches that contains
the three cleanups I did on top of Ben's work,
along with a now reduced fix for the reorder
timeout while scan thing, and a complete rework
of the RX flags to fix all issues with that
(where those issues are amsdu-in-ampdu, and the
use-after-free with the CMNTR flag)

Note also that this will conflict with my patch
"[PATCH wireless-2.6] mac80211: fix use-after-free"
as noted in that email.

johannes

