Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45241 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZHJUQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 16:16:11 -0400
Date: Mon, 10 Aug 2009 16:14:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Implement LP-PHY baseband table initialization
Message-ID: <20090810201431.GA6060@tuxdriver.com>
References: <4A806973.1020109@gmail.com> <4A806C2F.9070206@lwfinger.net> <69e28c910908101158nbc9477re66a203657b702f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910908101158nbc9477re66a203657b702f6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2009 at 08:58:44PM +0200, Gábor Stefanik wrote:
> 2009/8/10 Larry Finger <Larry.Finger@lwfinger.net>:
> > Gábor Stefanik wrote:
> >> Implement LP-PHY baseband table init for all revisions.
> >>
> >> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> >> ---
> >> Changes from RFC:
> >> -Improved table formatting in the code.
> >> -The 2GHz check in adjust_gain_table now uses b43_current_band.
> >> -Added a comment to rev2plus_table_init about a possible future
> >> improvement.
> >
> > I like the new table formatting.
> >
> > The comment in rev2plus_table_init has a typo - "ben" should be
> > "been". Otherwise it looks good. Thanks for all your work.
> >
> > Larry
> >
> 
> John, can you fix that when checking in, or should I resubmit with the
> typo fixed?

Sure, fine...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
