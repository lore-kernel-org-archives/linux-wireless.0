Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2BYVab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 16:30:31 -0500
Subject: Re: [RFCv2] cfg80211: 80Mhz Bandwidth channel flags in 5Gig band
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mahesh <maheshp@posedge.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Chakra Parvathaneni <chakra@posedge.com>
In-Reply-To: <CAJ-VmomfVCc0oQMjfwsrheC+Z2k3+-czo4F9GeeO=upHiHnQxg@mail.gmail.com> (sfid-20120225_202329_108179_7C3BAD32)
References: <f17c700977012ada368da4f339b9c639@posedge.com>
	 <1329933458.4657.2.camel@jlt3.sipsolutions.net>
	 <1329937072.4657.4.camel@jlt3.sipsolutions.net>
	 <4F471F40.8060503@posedge.com>
	 <1330070145.3426.8.camel@jlt3.sipsolutions.net>
	 <4F4772AB.9000305@posedge.com>
	 <CAJ-VmomfVCc0oQMjfwsrheC+Z2k3+-czo4F9GeeO=upHiHnQxg@mail.gmail.com>
	 (sfid-20120225_202329_108179_7C3BAD32)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Feb 2012 22:30:24 +0100
Message-ID: <1330205424.3509.5.camel@jlt3.sipsolutions.net> (sfid-20120225_223040_376232_949952B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-02-25 at 11:22 -0800, Adrian Chadd wrote:
> .. and this doesn't yet address VHT160, which is part of the 11ac spec too.
> 
> I think it's worth having a bit more of a total, overall architecture
> discussion about what 11ac support -should- look like before bits are
> comitted, so you don't have to go and change them later (and possibly
> break some internal company drivers whilst doing so.)

Not like I care about that at all ... we change things all the time and
break drivers in the process. Is it even feasible to have non-upstream
drivers on the current wireless stack? I'd think you'd have to dedicate
one person full time to following our mac80211 changes ;-)

> So - what else is likely needed for the upcoming 11ac standard?

Well so obviously we need things like VHT capability stuff (advertising,
in scans, in assoc, for AP/GO mode in station info). I suspect you're
talking only about the regulatory/channel stuff? Mostly I'm confused
about the split channel thing there but I suppose regulatory-wise it's
just like using two channels at the same time.

> Disclaimer: I'm speaking from my personal opinion rather than that of
> Qualcomm Atheros.

Does anyone here have an "official opinion"? I doubt it :)

johannes

