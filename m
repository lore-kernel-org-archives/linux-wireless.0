Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6039 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765030AbXILHrd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 03:47:33 -0400
Subject: [PATCH V4 wireless-dev#pending-upstream] Add iwlwifi wireless  drivers
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org
Cc: "John W.Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 12 Sep 2007 15:40:35 +0800
Message-Id: <1189582835.24707.118.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is the fourth version of the patch (against 2.6.23-rc4 wireless-dev
branch pending-upstream) adds the mac80211 based wireless drivers for
the Intel PRO/Wireless 3945ABG/BG Network Connection and Intel Wireless
WiFi Link AGN (4965) adapters. You can find it from:

http://intellinuxwireless.org/iwlwifi/v7-iwlwifi-add-iwlwifi-wireless-drivers.patch

BTW, do you think the 11n stuff can be kept in iwlwifi driver
pend-upstream? The pro is, although it is not used currently, we
maintain the same code base between the iwlwifi in upstream and in
wireless-dev. If you are strongly against it, I'll remove it (probably
with some script). Your call.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/Kconfig        |  129 +
 drivers/net/wireless/Makefile       |   12 +
 drivers/net/wireless/iwl-3945-hw.h  |  118 +
 drivers/net/wireless/iwl-3945-rs.c  |  979 ++++
 drivers/net/wireless/iwl-3945-rs.h  |  191 +
 drivers/net/wireless/iwl-3945.c     | 2290 +++++++++
 drivers/net/wireless/iwl-3945.h     |   41 +
 drivers/net/wireless/iwl-4965-hw.h  |  581 +++
 drivers/net/wireless/iwl-4965-rs.c  | 2118 ++++++++
 drivers/net/wireless/iwl-4965-rs.h  |  266 +
 drivers/net/wireless/iwl-4965.c     | 4719 ++++++++++++++++++
 drivers/net/wireless/iwl-4965.h     |  341 ++
 drivers/net/wireless/iwl-channel.h  |  161 +
 drivers/net/wireless/iwl-commands.h | 1734 +++++++
 drivers/net/wireless/iwl-debug.h    |  149 +
 drivers/net/wireless/iwl-eeprom.h   |  336 ++
 drivers/net/wireless/iwl-helpers.h  |  255 +
 drivers/net/wireless/iwl-hw.h       |  537 ++
 drivers/net/wireless/iwl-io.h       |  470 ++
 drivers/net/wireless/iwl-priv.h     |  308 ++
 drivers/net/wireless/iwl-prph.h     |  229 +
 drivers/net/wireless/iwl-spectrum.h |   91 +
 drivers/net/wireless/iwl3945-base.c | 8732 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwl4965-base.c | 9323 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi.h      |  713 +++
 25 files changed, 34823 insertions(+), 0 deletions(-)
