Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33739 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab0IOSbf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 14:31:35 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 00/04] wl1271: 11n Support, add support to 80211n spec
Date: Wed, 15 Sep 2010 20:31:08 +0200
Message-Id: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Series that add 80211n spec support to wl1271: scan, connection via MCS rates

Shahar Levi (4):
  wl1271: 11n Support, Add Definitions
  wl1271: 11n Support, ACX Commands
  wl1271: 11n Support, Scan, Connection, MCS rates
  wl1271: 11n Support, 11n Kconfig Configurable

 drivers/net/wireless/wl12xx/Kconfig       |    7 ++
 drivers/net/wireless/wl12xx/Makefile      |    4 +
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   91 +++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   96 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |    3 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   78 ++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_rx.c   |    4 +
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    9 +++
 9 files changed, 276 insertions(+), 18 deletions(-)

