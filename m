Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34720 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYJ3BT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 21:19:56 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 18:19:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/6] cfg80211: few regulatory updates
Date: Wed, 29 Oct 2008 18:19:48 -0700
Message-ID: <1225329594-21704-1-git-send-email-lrodriguez@atheros.com> (sfid-20081030_022000_829372_87CEA87E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a set of updates to cfg80211 for regulatory.
This paves the way for 11d support and also addresses
recent complaints about no working 5 GHz channels. I believe
the compromise is reasonable.

I haven't tested this yet though, but I'll let you know tomorrow
how they go. Just wanted to get these out for review for now.

I've tested intersection in userspace on CRDA, check out running
./intersect regulatory.bin for an example of it intersecting
all regulatory domains. Special review with this is greatly
appreciated.

Working on 11d should be fairly easy after this.

  Luis
