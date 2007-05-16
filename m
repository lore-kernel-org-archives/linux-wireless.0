Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:8641 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756579AbXEPW45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2007 18:56:57 -0400
Message-ID: <464B7B7C.5080800@linux.intel.com>
Date: Wed, 16 May 2007 14:45:32 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH]  Add iwlwifi wireless drivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the iwlwifi project directory and sources needed to 
build the mac80211 based wireless drivers for the Intel PRO/Wireless 
3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN adapters.

Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
 drivers/net/wireless/mac80211/Kconfig              |    1 +
 drivers/net/wireless/mac80211/Makefile             |    1 +
 drivers/net/wireless/mac80211/iwlwifi/Kconfig      |   96 +
 drivers/net/wireless/mac80211/iwlwifi/Makefile     |   27 +
 drivers/net/wireless/mac80211/iwlwifi/base.c       | 8146 ++++++++++++++++++++
 .../net/wireless/mac80211/iwlwifi/iwl-3945-hw.h    |   88 +
 .../net/wireless/mac80211/iwlwifi/iwl-3945-rs.h    |  175 +
 drivers/net/wireless/mac80211/iwlwifi/iwl-3945.c   | 2389 ++++++
 drivers/net/wireless/mac80211/iwlwifi/iwl-3945.h   |   54 +
 .../net/wireless/mac80211/iwlwifi/iwl-4965-hw.h    |  909 +++
 drivers/net/wireless/mac80211/iwlwifi/iwl-4965.c   | 3637 +++++++++
 drivers/net/wireless/mac80211/iwlwifi/iwl-4965.h   |  177 +
 .../net/wireless/mac80211/iwlwifi/iwl-channel.h    |  164 +
 .../net/wireless/mac80211/iwlwifi/iwl-commands.h   |  664 ++
 drivers/net/wireless/mac80211/iwlwifi/iwl-debug.h  |  141 +
 drivers/net/wireless/mac80211/iwlwifi/iwl-eeprom.h |  325 +
 .../net/wireless/mac80211/iwlwifi/iwl-helpers.h    |  250 +
 drivers/net/wireless/mac80211/iwlwifi/iwl-hw.h     | 1490 ++++
 drivers/net/wireless/mac80211/iwlwifi/iwl-io.h     |  454 ++
 drivers/net/wireless/mac80211/iwlwifi/iwl-priv.h   |  344 +
 .../net/wireless/mac80211/iwlwifi/iwl-spectrum.h   |   91 +
 drivers/net/wireless/mac80211/iwlwifi/iwlwifi.h    |  665 ++
 22 files changed, 20288 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/Kconfig
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/Makefile
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/base.c
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-3945-hw.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-3945-rs.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-3945.c
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-3945.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-4965-hw.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-4965.c
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-4965.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-channel.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-commands.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-debug.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-eeprom.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-helpers.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-hw.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-io.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-priv.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwl-spectrum.h
 create mode 100644 drivers/net/wireless/mac80211/iwlwifi/iwlwifi.h

NOTE:  The patch is 597k and can be found at:

	http://intellinuxwireless.org/iwlwifi/0001-Add-iwlwifi-wireless-drivers.patch

Patch is against wireless-dev commit-id be8662897~
