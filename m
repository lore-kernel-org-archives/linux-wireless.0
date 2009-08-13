Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26932 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbZHMUbO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/13] iwlwifi driver updates 08/13/2009
Date: Thu, 13 Aug 2009 13:30:49 -0700
Message-Id: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains quite a few patches related to HT. Most are cleaning
up code in this area with a few issues being fixed also. We complete the
work related to potential reads outside array bounds. This series adds
thermal throttling support to the 5150. We also make use of the new
cfg80211 feature to override the PS default and disable power save support
until the issues with it have been resolved. A new feature introduced in
this series is the ability to traverse OTP memory to obtain a valid EEPROM
image to read.

[PATCH 01/13] iwlwifi: prevent read outside array bounds
[PATCH 02/13] iwlwifi: remove unused HT configuration entry tx_chan_width
[PATCH 03/13] iwlwifi: include HT configuration when adding stations through rs_rate_init
[PATCH 04/13] iwlwifi: cleanup HT40 extension channels setup
[PATCH 05/13] iwlwifi: traverse linklist to find the valid OTP block
[PATCH 06/13] iwlwifi: remove unused members of iwl_ht_info
[PATCH 07/13] iwlwifi: refactor packet reception code
[PATCH 08/13] iwlwifi: configure HT40 channels in iwl_mac_config
[PATCH 09/13] iwlwifi: check short GI support per-station rather than globally
[PATCH 10/13] iwlwifi: use station HT capabilities and BSS operating mode for Green-field
[PATCH 11/13] iwlwifi: add thermal throttling support to 5150
[PATCH 12/13] iwlwifi: fix erroneous use of iwl_rx_packet.len as a length
[PATCH 13/13] iwlwifi: disable PS by default

Thanks

Reinette
