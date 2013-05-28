Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52947 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964858Ab3E1RpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 13:45:12 -0400
Date: Tue, 28 May 2013 13:37:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Thommy Jakobsson <thommyj@gmail.com>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	piotras@gmail.com
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
Message-ID: <20130528173736.GE2084@tuxdriver.com> (sfid-20130528_194521_012130_1E43577C)
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
 <CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com>
 <alpine.DEB.2.02.1305132025560.1278@kelly.ryd.net>
 <20130524164922.GA2175@tuxdriver.com>
 <alpine.DEB.2.02.1305252058060.1282@kelly.ryd.net>
 <51A112FC.8060100@hauke-m.de>
 <20130525214223.4e69a772@milhouse>
 <51A120EE.40008@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <51A120EE.40008@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 25, 2013 at 03:37:02PM -0500, Larry Finger wrote:
> On 05/25/2013 02:42 PM, Michael Büsch wrote:
> >On Sat, 25 May 2013 21:37:32 +0200
> >Hauke Mehrtens <hauke@hauke-m.de> wrote:
> >
> >>On 05/25/2013 09:02 PM, Thommy Jakobsson wrote:
> >>>
> >>>
> >>>On Fri, 24 May 2013, John W. Linville wrote:
> >>>
> >>>>Ping?  Should I drop this one?
> >>>>
> >>>Still working great on my device, so from that I think we should go for
> >>>it. But it would be great if Rafal (or someone) tested it on some other
> >>>hardware as well.
> >>>
> >>>//Thommy
> >>
> >>This is included in OpenWrt for ~4 weeks now and I haven't read of
> >>anybody complaining about any new problems introduced by this patch or
> >>something which looks like the DMA under run.
> >>I am also for adding this to the kernel.
> >
> >I'm probably missing something, but isn't this patch already in Linus' tree?
> >It's in stable review after all.
> 
> The patch is in wireless-testing with John's s-o-b, and in the
> mainline tree with the same annotation.
> 
> It has been working OK here, but my devices did not show underrun.

OK, thanks -- sorry for the confusion!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
