Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.248]:27823 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755990AbYBGQSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 11:18:00 -0500
Received: by hs-out-2122.google.com with SMTP id 54so2772697hsz.5
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2008 08:17:55 -0800 (PST)
Message-ID: <40f31dec0802070817r254155d0h9fd9c8f57bd7ab6c@mail.gmail.com> (sfid-20080207_161804_464365_B1CA874E)
Date: Thu, 7 Feb 2008 18:17:55 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: Getting Started
Cc: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"Neshama Parhoti" <pneshama@gmail.com>
In-Reply-To: <1202400904.1689.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <912ec82a0802070511y734f9836q244abb7800210961@mail.gmail.com>
	 <200802071435.17254.hs4233@mail.mn-solutions.de>
	 <40f31dec0802070704o59ca6f48x1ab5481303c60cec@mail.gmail.com>
	 <1202400596.1689.2.camel@localhost.localdomain>
	 <1202400904.1689.4.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/7, Dan Williams <dcbw@redhat.com>:
> On Thu, 2008-02-07 at 11:09 -0500, Dan Williams wrote:
> > On Thu, 2008-02-07 at 17:04 +0200, Nick Kossifidis wrote:
> > > > For example, the openmoko people are writing a mac80211 driver
> > > > for ar6k. Not every driver is already in the wireless-2.6 git
> > > > tree.
> > >
> > > [OT]
> > >
> > > As far as i know Atheros released a GPLed driver along with their SDIO stack.
> > > http://sourceforge.net/projects/sdio-linux/
> > >
> > > Do you have a plan to include this in kernel ? What's the status ?
> >
> > 2.6.24 already has an SDIO stack; hence the Atheros one is redundant.
> > The openmoko people already have a port of their ar6k driver to the
> > in-kernel SDIO stack.
>
> Which of course means that one big barrier to including the ar6k driver
> is already removed.  You can browse the ar6k openmoko code at:
>
> http://svn.openmoko.org/developers/sameo/patches/ar6k-ng/
>
> Dan
>
>

Great news !

Thnx for the info ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
