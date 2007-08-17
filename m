Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24051 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbXHQFdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 01:33:11 -0400
Subject: [PATCH] Add iwlwifi wireless drivers (resend)
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org
Cc: "John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 13:28:56 +0800
Message-Id: <1187328536.5763.137.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ My previous post doesn't show up on the list for a whole day. So I
resend it now. I guess the an 800k mail is too big for the list... ]

This patch (against 2.6.23-rc3) adds the mac80211 based
wireless drivers for the Intel PRO/Wireless 3945ABG/BG Network
Connection and Intel Wireless WiFi Link AGN (4965) adapters. I hope it
can be merged into 2.6.24 kernel. You comments are also welcome!

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 MAINTAINERS                         |   10 +
 drivers/net/wireless/Kconfig        |  129 +
 drivers/net/wireless/Makefile       |   29 +
 drivers/net/wireless/iwl-3945-hw.h  |  117 +
 drivers/net/wireless/iwl-3945-rs.c  |  985 ++++
 drivers/net/wireless/iwl-3945-rs.h  |  221 +
 drivers/net/wireless/iwl-3945.c     | 2286 +++++++++
 drivers/net/wireless/iwl-3945.h     |   60 +
 drivers/net/wireless/iwl-4965-hw.h  |  954 ++++
 drivers/net/wireless/iwl-4965-rs.c  | 2162 ++++++++
 drivers/net/wireless/iwl-4965-rs.h  |  286 ++
 drivers/net/wireless/iwl-4965.c     | 4764 +++++++++++++++++
 drivers/net/wireless/iwl-4965.h     |  368 ++
 drivers/net/wireless/iwl-base.c     | 9603
+++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwl-channel.h  |  163 +
 drivers/net/wireless/iwl-commands.h | 1515 ++++++
 drivers/net/wireless/iwl-debug.h    |  149 +
 drivers/net/wireless/iwl-eeprom.h   |  336 ++
 drivers/net/wireless/iwl-helpers.h  |  255 +
 drivers/net/wireless/iwl-hw.h       |  606 +++
 drivers/net/wireless/iwl-io.h       |  486 ++
 drivers/net/wireless/iwl-priv.h     |  305 ++
 drivers/net/wireless/iwl-spectrum.h |   91 +
 drivers/net/wireless/iwlwifi.h      |  715 +++


Please find the patch (and the original mail) from:

http://intellinuxwireless.org/iwlwifi/v4-Add-iwlwifi-wireless-drivers.patch


Thanks,
-yi
