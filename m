Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23797 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXLLBNK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 20:13:10 -0500
Subject: Re: mac80211 ethtool support
From: Zhu Yi <yi.zhu@intel.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200712111350.25522.mb@bu3sch.de>
References: <1197361048.3170.381.camel@debian.sh.intel.com>
	 <200712111350.25522.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 09:13:08 +0800
Message-Id: <1197421988.3170.405.camel@debian.sh.intel.com> (sfid-20071212_011315_737416_53064E57)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-11 at 13:50 +0100, Michael Buesch wrote:
> On Tuesday 11 December 2007 09:17:28 Zhu Yi wrote:
> > I want to add ethtool .get_eeprom and .get_eeprom_len support for
> > iwlwifi. But it seems mac80211 hides the netdev structure from the
> > driver. What's the suggested way for doing so (i.e dump EEPROM) for
> > mac80211 devices?
> 
> In ssb we simply create a sysfs file for this.

Yeah, we can do this also. But the users want a standard way, especially
when there is already such kernel interface and user space tools ready
there. Any chance mac80211 supports ethtool or something similar?

Thanks,
-yi
