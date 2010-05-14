Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:27316 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab0ENHrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 03:47:24 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/3] wl1271: patches for wk19
Date: Fri, 14 May 2010 10:46:21 +0300
Message-Id: <1273823184-9381-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here's v2 of our weekly patchset for the wl1271 driver, with no useless
internal tags.

Cheers,
Luca.

Juuso Oikarinen (3):
  wl1271: Update handling of the NVS file / INI parameters
  wl1271: Add support for NVS files with 5GHz band parameters
  wl1271: Fix RX data path frame lengths

 drivers/net/wireless/wl12xx/wl1271.h          |   28 +------
 drivers/net/wireless/wl12xx/wl1271_cmd.c      |   25 +++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h      |   26 +++--
 drivers/net/wireless/wl12xx/wl1271_ini.h      |  123 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c     |   13 ++-
 drivers/net/wireless/wl12xx/wl1271_rx.c       |    2 +
 drivers/net/wireless/wl12xx/wl1271_testmode.c |   11 ++-
 7 files changed, 177 insertions(+), 51 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_ini.h

