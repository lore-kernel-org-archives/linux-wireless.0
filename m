Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50335 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYIVTsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 15:48:16 -0400
Date: Mon, 22 Sep 2008 15:47:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Steven Noonan <steven@uplinklabs.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Howard Chu <hyc@symas.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k problems
Message-ID: <20080922194739.GB3660@tuxdriver.com> (sfid-20080922_214821_348846_B3023D4E)
References: <48D5CAD0.1080909@symas.com> <f488382f0809202122v4c77bc96r54edd24bdf365724@mail.gmail.com> <20080922064831.GB19580@tesla> <f488382f0809220021qc1a3abatada16972eea1d44c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f488382f0809220021qc1a3abatada16972eea1d44c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 12:21:52AM -0700, Steven Noonan wrote:
> On Sun, Sep 21, 2008 at 11:48 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> >> but wireless-testing is pretty outdated
> >
> > This is not accurate.
> >
> > It lacks new patches from Linus' tree, but it has the latest
> > and greatest possible wireless patches. John maintains Linux
> > wireless so he'll always have more updated patches for wireless than
> > Linus.
> >
> 
> I've had much less luck running wireless-testing than I have had
> running -tip or Linus' trees. Perhaps it -is- inaccurate that it's
> outdated, but it's certainly less usable, from what I've seen.

The wireless-testing tree is based on an -rc from Linus plus any later
wireless patches (minus whatever is still sitting in my mailbox at
the time).  If it is less usable, it is either due to some wireless
breakage (send us bug reports) or Linus is producing crap -rc releases
(possible).

Current wireless-testing is based on 2.6.27-rc6.  Since -rc7 just
came-out yesterday...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
