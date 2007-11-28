Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759466AbXK1B22 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 20:28:28 -0500
Subject: Re: iwlwifi driver vs. mac80211 vs. duplicate transmissions etc.
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1196110618.13733.2.camel@johannes.berg>
References: <1196110618.13733.2.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 09:28:24 +0800
Message-Id: <1196213304.7614.45.camel@debian.sh.intel.com> (sfid-20071128_012833_091095_00F89CED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-11-26 at 21:56 +0100, Johannes Berg wrote:
> Is there any reason the driver tries to drop duplicate packets, out of
> order fragments etc? That's just extra code and mac80211 does that
> already.

We took over that function from ipw2200 in the beginning of iwlwifi.
I'll go through the mac80211 drop duplicate function and remove the one
in iwlwifi if necessary.

Thanks,
-yi
