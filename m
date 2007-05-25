Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbXEYLwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2007 07:52:08 -0400
Date: Fri, 25 May 2007 19:52:05 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: [TAKE 2][PATCH 0/3] IEEE802.11e/WMM TS management and DLS support
Message-ID: <20070525115205.GA23301@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The following patches updated my previous IEEE802.11e/WMM patches
based on the comments from Michael Wu. Please apply.

[PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
[PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS support
[PATCH 3/3] mac80211: debugfs support for TSM and DLS

Thanks,
-yi
