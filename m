Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42250 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab0I3WVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 18:21:04 -0400
Received: by qyk33 with SMTP id 33so2539710qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 15:21:03 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Sep 2010 18:21:02 -0400
Message-ID: <AANLkTi=YWBQyompixojg82x01KvWe3-0AqW5eL8rH+US@mail.gmail.com>
Subject: [PATCH 0/3] patches for WDS interfaces
From: Bill Jordan <bjordan@rajant.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please ignore my previous patch submissions.

With these patches, I'm able to interoperate over WDS between
linux-wireless and MadWifi. I'm running wireless-testing plus OpenWRT
patches on a Cambria board with an AR9160 radio.

Bill Jordan (3):
  Patches to ath9k for WDS.
  Patches to cfg80211 to allow setting the WDS peer.
  Patches to mac80211 to allow WDS interfaces to pass packets.

 drivers/net/wireless/ath/ath9k/init.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    3 ++
 include/linux/nl80211.h               |    3 ++
 net/mac80211/iface.c                  |    3 ++
 net/mac80211/main.c                   |    3 ++
 net/mac80211/rx.c                     |    1 +
 net/mac80211/tx.c                     |    3 ++
 net/wireless/nl80211.c                |   49 +++++++++++++++++++++++++++++++++
 8 files changed, 66 insertions(+), 0 deletions(-)

-- 
1.7.2.3
