Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5799 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbZH1Qos (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 12:44:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates 8/28/2009
Date: Fri, 28 Aug 2009 09:44:44 -0700
Message-Id: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we continue the work to refactor and correct iwlwifi's HT rate behavior.
The sleep intervals used during dynamic powersave is adjusted. We also
include a fix for an error being printed incorrectly.

[PATCH 1/5] iwlwifi: remove 60 Mbps from sband bitrates table
[PATCH 2/5] iwlwifi: remove incorrect uses of ieee80211_get_tx_rate to prevent TX stall
[PATCH 3/5] iwlwifi: use iwl_hwrate_get_mac80211_idx where appropriate
[PATCH 4/5] iwlwifi: use sleep interval succession
[PATCH 5/5] iwlwifi: fix situation in which debug message is printed

Thank you

Reinette

