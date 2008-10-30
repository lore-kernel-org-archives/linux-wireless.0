Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22485 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbYJ3Ud6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:33:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 13:33:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/5 v2] cfg80211: few regulatory updates
Date: Thu, 30 Oct 2008 13:33:51 -0700
Message-ID: <1225398836-28633-1-git-send-email-lrodriguez@atheros.com> (sfid-20081030_213402_240001_0CBB4E48)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a set of updates to cfg80211 for regulatory. This paves
the way for 11d support. Working on 11d should be fairly easy
after this. These patches are now tested.

  Luis
