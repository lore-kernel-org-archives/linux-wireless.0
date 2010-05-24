Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:58393 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0EXISc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:18:32 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] wl1271: patches for wk20
Date: Mon, 24 May 2010 11:18:14 +0300
Message-Id: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here's our weekly patchset for the wl1271 driver, which contains the changes we
made last week.

Cheers,
Luca.

Juuso Oikarinen (5):
  wl1271: Prevent dropping of TX frames in joins
  wl1271: Idle handling into own function
  wl1271: Flush TX buffers to air before going to idle
  wl1271: Use proper rates for PSM entry/exit null-funcs for 5GHz
  wl1271: Fix scan parameter handling for 5GHz

Luciano Coelho (1):
  wl1271: the core wl1271 module shouldn't depend on SPI_MASTER

 drivers/net/wireless/wl12xx/Kconfig        |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h       |    3 +
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   16 ++----
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    2 +-
 drivers/net/wireless/wl12xx/wl1271_event.c |   10 ++--
 drivers/net/wireless/wl12xx/wl1271_main.c  |   76 +++++++++++++++++++--------
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   36 ++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_tx.h    |    1 +
 8 files changed, 103 insertions(+), 43 deletions(-)

