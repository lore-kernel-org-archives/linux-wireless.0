Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42948 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2FLUHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 16:07:34 -0400
Received: by eaak11 with SMTP id k11so2326207eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 13:07:33 -0700 (PDT)
From: Lekensteyn <lekensteyn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Why "iwlwifi: read multiple MAC addresses"?
Date: Tue, 12 Jun 2012 22:07:27 +0200
Message-ID: <3484697.jSSpon72n2@penguin> (sfid-20120612_220738_054158_3D14262C)
In-Reply-To: <1339531131.4531.22.camel@jlt3.sipsolutions.net>
References: <3586963.qbQ3i1FPTG@penguin> <1339531131.4531.22.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 June 2012 21:58:51 Johannes Berg wrote:
> On Tue, 2012-06-12 at 15:11 +0200, Lekensteyn wrote:
> > Looking at a dump provided by
> > /sys/kernel/debug/cfg80211/phy0/iwlwifi/data/nvm, I see that the 16-bit
> > word at 0x98 contains the value 4. What does this mean?
> The 4 actually means that there are 4 addresses assigned to this device,
> for use in P2P scenarios etc. We only support 2 virtual interfaces in
> Linux today, so we don't expose 4 (though we probably could.)
> 
> > Can this break something?
> 
> No.

Okay, thanks for your quick answer. I have noticed that the first address is 
stored at 0x3A while the second one is stored at 0x92. Did you make an 
assumption that this address is other address + 1?

Regards,
Peter
