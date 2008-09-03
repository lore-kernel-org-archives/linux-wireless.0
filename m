Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39735 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYICXab (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 19:30:31 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 v3.14] New regulatory infrastructure for cfg80211 and drivers
Date: Wed, 3 Sep 2008 16:30:22 -0700
Message-ID: <1220484624-7808-1-git-send-email-lrodriguez@atheros.com> (sfid-20080904_013034_191266_161CE1F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds the new regulatory infrastructure for
cfg80211. Since it has not been merged yet I am resending
with the pending patches applied on top and a better
descriptive commit message.

I now also take into consideration leaving as an option the
old static definitions and module parameter for one kernel
release cycle. It is scheduled to be removed for good for 2.6.29.

This patch depends on application of the application of the patch:

"cfg80211: keep track of supported interface modes"

  Luis
