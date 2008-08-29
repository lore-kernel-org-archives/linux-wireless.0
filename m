Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39788 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYH2W7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 18:59:22 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] New regulatory infrastructure for cfg80211 and drivers
Date: Fri, 29 Aug 2008 15:59:16 -0700
Message-ID: <1220050758-11939-1-git-send-email-lrodriguez@atheros.com> (sfid-20080830_005924_514470_70F95B10)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds the new regulatory infrastructure for
cfg80211. Since it has not been merged yet I am resending
with the pending patches applied on top and a better
descriptive commit message.

This patch depends on application of the application of the patch:

"cfg80211: keep track of supported interface modes"

After this I will tackle 802.11d parsing and integration
along with regulatory intersection capabilities.

  Luis
