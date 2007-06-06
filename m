Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21151 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbXFFIWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2007 04:22:24 -0400
Date: Wed, 6 Jun 2007 16:21:54 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: IEEE802.11e/WMM TS management and DLS support
Message-ID: <20070606082152.GA28639@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a patch series for IEEE802.11e/WMM support against
linux-2.6.22-rc4.

[PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
[PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS support
[PATCH 3/3] mac80211: debugfs support for TSM and DLS


Thanks,
-yi
