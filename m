Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6039 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765156AbXILHrb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 03:47:31 -0400
Subject: [PATCH wireless-dev#iwlwifi] update iwlwifi drivers to 0.1.15
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org
Cc: "John W.Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 12 Sep 2007 15:40:34 +0800
Message-Id: <1189582834.24707.117.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patch (against wireless-dev GIT iwlwifi branch) updates the iwlwifi
driver to version 0.1.15. It also splits the iwlwifi code base into 3945
and 4965 separately. Please apply.

http://intellinuxwireless.org/iwlwifi/iwlwifi-wireless-dev-01.patch

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/Makefile       |   25 +-
 drivers/net/wireless/iwl-3945-hw.h  |   14 +
 drivers/net/wireless/iwl-3945-rs.c  |   34 +-
 drivers/net/wireless/iwl-3945-rs.h  |   36 +-
 drivers/net/wireless/iwl-3945.c     |  158 +-
 drivers/net/wireless/iwl-3945.h     |   19 -
 drivers/net/wireless/iwl-4965-hw.h  |  407 +--
 drivers/net/wireless/iwl-4965-rs.c  |  236 +-
 drivers/net/wireless/iwl-4965-rs.h  |   82 +-
 drivers/net/wireless/iwl-4965.c     |  554 +--
 drivers/net/wireless/iwl-4965.h     |   58 +-
 drivers/net/wireless/iwl-base.c     | 9565
-----------------------------------
 drivers/net/wireless/iwl-channel.h  |    6 +-
 drivers/net/wireless/iwl-commands.h | 1526 +++++-
 drivers/net/wireless/iwl-debug.h    |    4 +-
 drivers/net/wireless/iwl-eeprom.h   |   52 +-
 drivers/net/wireless/iwl-hw.h       | 1294 +-----
 drivers/net/wireless/iwl-io.h       |  150 +-
 drivers/net/wireless/iwl-priv.h     |   12 +-
 drivers/net/wireless/iwl-prph.h     |  229 +
 drivers/net/wireless/iwl3945-base.c | 8732
++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwl4965-base.c | 9323
++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi.h      |  131 +-
 23 files changed, 20404 insertions(+), 12243 deletions(-)
 delete mode 100644 drivers/net/wireless/iwl-base.c
 create mode 100644 drivers/net/wireless/iwl-prph.h
 create mode 100644 drivers/net/wireless/iwl3945-base.c
 create mode 100644 drivers/net/wireless/iwl4965-base.c
