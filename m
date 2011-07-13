Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab1GMIlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:24 -0400
Message-Id: <20110713083908.713123063@sipsolutions.net> (sfid-20110713_104127_969576_247AD1EA)
Date: Wed, 13 Jul 2011 10:39:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/11] wext reductio
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So ... Kalle posted ath6kl which erroneously used
wext constants and I noticed that he can do that
only because cfg80211 includes the wext headers.
Then I found mac80211 does the same, so I went on
a little cleanup spree. :-)

johannes

