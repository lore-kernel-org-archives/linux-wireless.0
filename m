Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10859 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbZIAPWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:22:45 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:22:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/7] wireless: few kconfig updates
Date: Tue, 1 Sep 2009 08:22:39 -0700
Message-ID: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since it seems the organizational changes on kconfig for wireless
drivers did not go through I am sending now only the net/wireless and
net/mac80211 wireless kconfig updates. This updates the description of
the wireless options to reflect better with our documentation on
wireless.kernel.org and we also provide pointers for further
documentation.

Luis R. Rodriguez (7):
  wireless: update top level wireless driver entry
  wireless: update wireless kconfig description
  wireless: update cfg80211 kconfig entry
  wireless: update reg debug kconfig entry
  wireless: update WIRELESS_EXT kconfig entry
  wireless: update mac80211 kconfig entry
  wireless: remove mac80211 rate selection extra menu

 drivers/net/wireless/Kconfig |   13 +++++++++++--
 net/Kconfig                  |    8 +++++++-
 net/mac80211/Kconfig         |   24 ++++++++++++++++++------
 net/wireless/Kconfig         |   27 ++++++++++++++++++++++++---
 4 files changed, 60 insertions(+), 12 deletions(-)

