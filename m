Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54193 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0JFSG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:29 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v2 00/03] wl1271: 11n Support, add support to 80211n spec
Date: Wed,  6 Oct 2010 20:08:07 +0200
Message-Id: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Series that add 80211n spec support to wl1271: scan, connection via MCS rates
Wl12xx driver add HT support:
· Scan includes HT IE
· Connection to HT devices
· HT protection
· Traffic via MCS rates
· A-MSDU in RX path

Missing functionality is:
· BA session as Initiator and Receiver

Shahar Levi (3):
  wl1271: 11n Support, Add Definitions
  wl1271: 11n Support, ACX Commands
  wl1271: 11n Support, functionality and configuration ability

 drivers/net/wireless/wl12xx/Kconfig       |   10 +++
 drivers/net/wireless/wl12xx/Makefile      |    1 +
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   91 +++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   95 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |    4 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   78 ++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_rx.c   |    4 +
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    9 +++
 9 files changed, 276 insertions(+), 18 deletions(-)

