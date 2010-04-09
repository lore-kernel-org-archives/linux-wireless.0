Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33036 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab0DIIH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 04:07:59 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] wl1271: patches of the week wk14
Date: Fri,  9 Apr 2010 11:07:25 +0300
Message-Id: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are our patches of the week for the wl1271 driver.  Please apply.

Cheers,
Luca.


Juuso Oikarinen (3):
  wl1271: Fix memory leaks on driver initialization
  wl1271: Go to ELP in idle
  wl1271: Add support for connection quality monitoring

Saravanan Dhanabal (2):
  wl1271: Fix mac80211 configuration requests during WL1271_STATE_OFF
  wl1271: Fix mac80211 RTS threshold requests during WL1271_STATE_OFF

 drivers/net/wireless/wl12xx/wl1271.h       |    4 +
 drivers/net/wireless/wl12xx/wl1271_acx.c   |   71 +++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h   |   56 +++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_boot.c  |    3 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h  |  103 ++++++++++-----------------
 drivers/net/wireless/wl12xx/wl1271_event.c |   24 +++++++
 drivers/net/wireless/wl12xx/wl1271_event.h |    8 ++
 drivers/net/wireless/wl12xx/wl1271_init.c  |    5 ++
 drivers/net/wireless/wl12xx/wl1271_main.c  |   84 +++++++++++++----------
 drivers/net/wireless/wl12xx/wl1271_ps.c    |    6 +-
 10 files changed, 259 insertions(+), 105 deletions(-)

