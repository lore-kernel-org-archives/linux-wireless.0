Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50440 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1ACNlN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 08:41:13 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 0/2] wl12xx: BA Initiator & receiver support
Date: Mon,  3 Jan 2011 15:42:42 +0200
Message-Id: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That series gather two patches:
[PATCH v5] wl12xx: BA initiator support
[PATCH v3] wl12xx: BA receiver support

Add 80211n BA initiator & receiver session support wl1271 driver.
BA initiator session management included in FW independently.
Include supported FW version auto detection mechanism.

Next step is to implement HW flag that in case of wl12xx driver indicates
  mac80211 to use BA win size of 8.

Shahar Levi (2):
  wl12xx: BA initiator support
  wl12xx: BA receiver support

 drivers/net/wireless/wl12xx/acx.c    |   86 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   62 +++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/boot.c   |   41 +++++++++++++++-
 drivers/net/wireless/wl12xx/conf.h   |    7 +++
 drivers/net/wireless/wl12xx/init.c   |   50 ++++++++++++++++++++
 drivers/net/wireless/wl12xx/main.c   |   73 +++++++++++++++++++++++++++--
 drivers/net/wireless/wl12xx/wl12xx.h |   15 ++++++-
 7 files changed, 323 insertions(+), 11 deletions(-)

