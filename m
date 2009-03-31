Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZCaKQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 06:16:08 -0400
Message-Id: <20090331101204.540183860@sipsolutions.net> (sfid-20090331_121611_568162_32D75998)
Date: Tue, 31 Mar 2009 12:12:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Subject: [PATCH v3 0/3] mac80211/cfg80211 scan improvements
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We currently don't tell userspace what the max IE length is,
fix that. We also have hw_scan build the probe request, which
is not necessary, mac80211 can do that.

I have, but will submit over a different channel, a patch to
fix up iwlwifi to support proper scanning after this series.

johannes

