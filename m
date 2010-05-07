Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43351 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab0EGIj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 04:39:57 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] wl1271: patches for wk18
Date: Fri,  7 May 2010 11:38:57 +0300
Message-Id: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here's our weekly patchset for the wl1271 driver.

Cheers,
Luca.


Juuso Oikarinen (4):
  wl1271: Add sysfs file to retrieve HW PG-version and ROM-version
  wl1271: Fix 32 bit register read related endiannes bug
  wl1271: Fix to join and channel number handling
  wl1271: Reduce PSM entry hang over period from 128 => 1 ms

Teemu Paasikivi (1):
  wl1271: Increase timeout for command event waiting

 drivers/net/wireless/wl12xx/wl1271.h      |    4 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c |   12 +++++
 drivers/net/wireless/wl12xx/wl1271_boot.h |    3 +
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_io.h   |    4 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   63 ++++++++++++++++++++++++++---
 7 files changed, 79 insertions(+), 11 deletions(-)

