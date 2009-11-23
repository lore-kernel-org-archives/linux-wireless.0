Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40104 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbZKWVXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:23:00 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] wl1271 patches of the week
Date: Mon, 23 Nov 2009 23:22:11 +0200
Message-Id: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John et al,

Here are some patches that were still pending on our internal tree.  They are
mostly fixes, without any new implementation.

Cheers,
Luca.


Juuso Oikarinen (3):
  wl1271: Decrease BET consecutive terminated beacons value to 10
  wl1271: Prevent PSM-entry retry loop if PSM cancelled
  wl1271: Set PSM support flags in driver configuration

Luciano Coelho (5):
  wl1271: fix the inetdev notifier callback return values
  wl1271: set radio and general params also for PLT
  wl1271: fix radio and general parameters commands
  wl1271: remove workaround to ignore -EIO from radio and general
    params
  wl1271: Remove REF_CLK hack

 drivers/net/wireless/wl12xx/wl1271_cmd.c   |  107 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |   72 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_event.c |    8 ++-
 drivers/net/wireless/wl12xx/wl1271_init.c  |  117 +---------------------------
 drivers/net/wireless/wl12xx/wl1271_init.h  |   70 -----------------
 drivers/net/wireless/wl12xx/wl1271_main.c  |   32 ++++----
 6 files changed, 206 insertions(+), 200 deletions(-)

