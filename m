Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64219 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbYKECuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 21:50:08 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 18:50:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/7] cfg80211/mac80211: Add 802.11d support
Date: Tue, 4 Nov 2008 18:49:59 -0800
Message-ID: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com> (sfid-20081105_035015_013322_EF86294D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds 802.11d support to mac80211 and
cfg80211. I've tried to split the required changes as much
as possible to make it easier for review. I've tested this
on iwlagn with OLD_REG enabled and disable and with /sbin/crda
missing and not. I'm sure I've missed a few corner cases, but
I think this is a good start.

  Luis
