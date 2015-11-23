Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51076 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbbKWQPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 11:15:20 -0500
Date: Mon, 23 Nov 2015 11:02:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: wireless-testing repo
Message-ID: <20151123160159.GA3755@tuxdriver.com> (sfid-20151123_171917_126318_BD1E34D0)
References: <5652F62A.4000109@broadcom.com>
 <1448278260.5792.1.camel@sipsolutions.net>
 <5652FAB5.8030708@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5652FAB5.8030708@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2015 at 12:38:29PM +0100, Arend van Spriel wrote:
> On 11/23/2015 12:31 PM, Johannes Berg wrote:
> >On Mon, 2015-11-23 at 12:19 +0100, Arend van Spriel wrote:
> >>Hi John,
> >>
> >>We have been using the wireless-testing repo in our nightly testing
> >>and as such appreciated the on-going support for it. I noticed your
> >>announcement (and misplaced it) and as I prefer to keep the nightly
> >>testing will have to do the work over here. Can you provide details
> >>on what trees are merged into wireless-testing. Is it
> >>wireless-drivers{,-next} and mac80211{,-next} or is there more to
> >>consider.
> >
> >I believe it was also the latest rc from Linus.
> 
> Indeed.

Yes, latest -rc plus those 4 trees is what I have been pulling for
some time.  I used to include Bluetooth and NFC, but stopped doing
that early this year.

> >If you're testing with backports you could also use the latest linux-
> >next with a restricted backport - I've added mac80211(-next) to that
> >now.
> 
> We have some setups running on wl-testing kernel and some running distro
> kernel using backports.

I believe the Bob Copeland is considering taking on this mantle...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
