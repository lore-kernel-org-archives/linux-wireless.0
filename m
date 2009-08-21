Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551AbZHUUe1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/14] iwlwifi and ipw2x00 driver updates
Date: Fri, 21 Aug 2009 13:34:13 -0700
Message-Id: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include a few fixes surrounding TX power. We support enhanced TX power
information provided by newer hardware. The fixes to HT continue. We also
include two general bugfixes: fix error when bringing interface down
that has hardware key set and cancelling scan when bringing interface
down.

We also include two administrative patches to ipw2x00 to update maintenance
status and contact information.

[PATCH 01/14] iwlwifi: set default tx power user limit to minimal
[PATCH 02/14] iwlwifi: do not allow set tx power over channel power limit
[PATCH 03/14] iwlwifi: name changes from "tx_power_channel_lmt" to "tx_power_device_lmt"
[PATCH 04/14] iwlwifi: error checking for setting tx_power in sysfs
[PATCH 05/14] iwlwifi: change IWL6000_UCODE_API_MAX to v4
[PATCH 06/14] iwlwifi: show current tx power
[PATCH 07/14] iwlwifi: clear rate control flags on non-HT packet
[PATCH 08/14] iwlwifi: set HT flags in ieee80211_rx_status for received packets
[PATCH 09/14] iwlwifi: remove duplicated define
[PATCH 10/14] iwlwifi: read enhanced tx power info from EEPROM image
[PATCH 11/14] iwlwifi: fix remove key error
[PATCH 12/14] iwlwifi: fix unloading driver while scanning
[PATCH 13/14] ipw2x00: update contact information
[PATCH 14/14] MAINTAINERS: Update ipw2x00 and iwlwifi entries


Thank you

Reinette

