Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51458 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbZKBSWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 13:22:23 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] wl1271: some robustness improvements
Date: Mon,  2 Nov 2009 20:22:07 +0200
Message-Id: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are some more patches for the wl1271 driver.  A few small issues have been fixed and some other improvements.

Cheers,
Luca.

Juuso Oikarinen (6):
  wl1271: Remove excess null-data template settings
  wl1271: Increase TX power value
  wl1271: Check result code of commands
  wl1271: Add retry implementation for PSM entries
  wl1271: Correct endianness-handling of command status
  wl1271: Generalize command response reading

 drivers/net/wireless/wl12xx/wl1271.h       |    3 +
 drivers/net/wireless/wl12xx/wl1271_acx.c   |    2 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c  |    3 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   99 ++++++++++------------------
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    3 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h  |    8 ++
 drivers/net/wireless/wl12xx/wl1271_event.c |   53 +++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_event.h |    7 ++
 drivers/net/wireless/wl12xx/wl1271_init.c  |    7 ++-
 drivers/net/wireless/wl12xx/wl1271_main.c  |   19 +++---
 10 files changed, 126 insertions(+), 78 deletions(-)

