Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3197 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbXLKIRq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 03:17:46 -0500
Subject: mac80211 ethtool support
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 11 Dec 2007 16:17:28 +0800
Message-Id: <1197361048.3170.381.camel@debian.sh.intel.com> (sfid-20071211_081751_659282_DA741E72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I want to add ethtool .get_eeprom and .get_eeprom_len support for
iwlwifi. But it seems mac80211 hides the netdev structure from the
driver. What's the suggested way for doing so (i.e dump EEPROM) for
mac80211 devices?

Thanks,
-yi
