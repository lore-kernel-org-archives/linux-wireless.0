Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52840 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYICNPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 09:15:31 -0400
Date: Wed, 3 Sep 2008 09:04:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: at76_usb.[ch] gone fishing from wireless-testing ?
Message-ID: <20080903130439.GJ3050@tuxdriver.com> (sfid-20080903_151535_796206_8150204D)
References: <43e72e890809021953o29c6ba53wcdf7630d4ff10b30@mail.gmail.com> <87vdxedje8.fsf@nokia.com> <43e72e890809022003gfd462d2ma8d68f032754c121@mail.gmail.com> <20080903125352.GI3050@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080903125352.GI3050@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 03, 2008 at 08:53:52AM -0400, John W. Linville wrote:
> On Tue, Sep 02, 2008 at 08:03:32PM -0700, Luis R. Rodriguez wrote:
> > On Tue, Sep 2, 2008 at 7:59 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> > > Luis R. Rodriguez <mcgrof@gmail.com> writes:
> > >
> > >> A few times now I've git-fetch'd origin and noticed at76_usb.[ch]
> > >> missing on origin/master. Strange, wondering if you're aware of any
> > >> such type of issues or its just me.
> > >
> > > Good point, I don't see it either. But at76_usb is quite broken
> > > currently, so maybe John decided just to drop it? Good choice, at
> > > least for now.
> > >
> > > And it's not just that, also -wl suffix is missing from the version.
> > >
> > > My HEAD is currently:
> > >
> > > commit 18c8adeb0244f823ba78a51e23f813fe68bc3c54
> > > Author: Michael Buesch <mb@bu3sch.de>
> > > Date:   Thu Aug 28 19:33:40 2008 +0200
> > >
> > >    b43: Rewrite TX power adjustment
> > 
> > I'm at:
> > 
> > commit 908dd0b965e64fcc2eb64152bac65f2876c34e0b
> > Author: Senthil Balasubramanian <senthilkumar@atheros.com>
> > Date:   Mon Sep 1 19:58:20 2008 +0530
> >     ath9: Fix ath_rx_flush_tid() for IRQs disabled kernel warning message.
> > 
> > Reason I find it strange is on one box it went through and I still see
> > history for it, and in another I don't. I was going to do a fresh pull
> > to test but figure I rather ask as bandwidth is crummy at work.
> 
> Crap, I botched my lastest update.  I'll pull in the part that adds
> -wl to the version for sure.  Anyone want to talk me out of pulling-in
> the at76 parts?

Hmmm...upon further review, both my local copy and the one at
kernel.org seem to have the proper bits AFAICT...?

-- 
John W. Linville
linville@tuxdriver.com
