Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZDTVbB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:01 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/11] iwlwifi driver updates 04/20/2009
Date: Mon, 20 Apr 2009 14:36:53 -0700
Message-Id: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233106_640869_0F9503A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A few fixes and cleanup. Could you please send the first patch to 2.6.30
also? Patches 2 to 4 are waited upon and also address the "iwl3945
registration regression" reported in
http://marc.info/?l=linux-wireless&m=123925660426062&w=2 and applies on top
of the fix that Johannes posted for it there
(http://marc.info/?l=linux-wireless&m=123926378000661&w=2 ).

[PATCH 01/11] iwlwifi: fix EEPROM validation mask to include OTP only devices
[PATCH 02/11] iwlwifi: rename PROBE_OPTION_MAX_API1 to PROBE_OPTION_MAX_3945
[PATCH 03/11] iwlwifi: improve scan support
[PATCH 04/11] iwlwifi: support truly passive scanning
[PATCH 05/11] iwl3945: add debugfs to 3945
[PATCH 06/11] iwl3945: calculate debugfs isr statistics
[PATCH 07/11] iwlwifi: clean up unused NL80211_IFTYPE_MONITOR for Monitor mode
[PATCH 08/11] iwl3945: use cancel_delayed_work_sync to cancel rfkill_poll
[PATCH 09/11] iwlcore: Fix stay in table function.
[PATCH 10/11] iwlwifi: remove radio disable parameter.
[PATCH 11/11] iwlwifi: allow config if device not ready


Thank you

Reinette
