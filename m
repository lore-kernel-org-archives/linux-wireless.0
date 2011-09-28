Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1I1MMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 08:12:45 -0400
Message-Id: <20110928120849.882884360@sipsolutions.net> (sfid-20110928_141249_243564_22D2F86A)
Date: Wed, 28 Sep 2011 14:08:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/15] mac80211 uAPSD support
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've tested this more, and am happy with it. There'll probably
be some bugs, but hopefully nothing bad.

The series now also comes with documentation.

Drivers still need to enable uAPSD on a per-driver basis since
it isn't guaranteed that they support it.

Note that this requires my previous patch
"cfg80211/mac80211: apply station uAPSD parameters selectively"

I've also based this series on Arik's TDLS support patches. I
guess you can read that as an endorsement of his patches :-)

johannes

