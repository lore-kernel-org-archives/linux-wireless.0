Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56922 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751189AbbJEMSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 08:18:54 -0400
Message-ID: <1444047527.27220.7.camel@coelho.fi> (sfid-20151005_141857_411391_27594B0D)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
	Hauke Mehrtens <hauke@hauke-m.de>, emmanuel.grumbach@intel.com
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Date: Mon, 05 Oct 2015 15:18:47 +0300
In-Reply-To: <1442949387.2018.50.camel@sipsolutions.net>
References: <1442659190-6060-1-git-send-email-hauke@hauke-m.de>
	 (sfid-20150919_124007_995516_62A820AE) <1442911476.2018.2.camel@sipsolutions.net>
	 (sfid-20150922_104447_027012_36D311B0) <1442911617.2018.3.camel@sipsolutions.net>
	 <5601A883.1010209@hauke-m.de> <1442949387.2018.50.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: fix requested firmware name for iwlwifi-3160
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-09-22 at 21:16 +0200, Johannes Berg wrote:
> > 
> > Should I change something?
> 
> No, I already created a different patch to make it simply use the
> 7260
> number instead of the 3165 one. I also made one, in fact, to get rid
> of
> the 3165 since that has the same values anyway.
> 
> > iwl3165 uses iwl3160 firmware, but support for that was added in
> > rev 
> > 13 of that firmware. That's the information I got from the driver
> > and
> > the linux-firmware commit messages.
> > 
> 
> Ah. it may be that we have changed this internally vs. upstream, need
> to check on that. Actually, Luca will just find out when he tries to
> upstream my changes :)

Just saw this now because... I'm preparing our patches for upstreaming.
:)

But I didn't notice anything regarding this when I cherry-picked your
patch for upstreaming.  Did I miss something?

--
Luca.
