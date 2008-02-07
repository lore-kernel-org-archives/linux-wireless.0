Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbYBGQPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 11:15:23 -0500
Subject: Re: Getting Started
From: Dan Williams <dcbw@redhat.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	Neshama Parhoti <pneshama@gmail.com>
In-Reply-To: <1202400596.1689.2.camel@localhost.localdomain>
References: <912ec82a0802070511y734f9836q244abb7800210961@mail.gmail.com>
	 <200802071435.17254.hs4233@mail.mn-solutions.de>
	 <40f31dec0802070704o59ca6f48x1ab5481303c60cec@mail.gmail.com>
	 <1202400596.1689.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 11:15:04 -0500
Message-Id: <1202400904.1689.4.camel@localhost.localdomain> (sfid-20080207_161531_814400_177E1315)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-07 at 11:09 -0500, Dan Williams wrote:
> On Thu, 2008-02-07 at 17:04 +0200, Nick Kossifidis wrote:
> > > For example, the openmoko people are writing a mac80211 driver
> > > for ar6k. Not every driver is already in the wireless-2.6 git
> > > tree.
> > 
> > [OT]
> > 
> > As far as i know Atheros released a GPLed driver along with their SDIO stack.
> > http://sourceforge.net/projects/sdio-linux/
> > 
> > Do you have a plan to include this in kernel ? What's the status ?
> 
> 2.6.24 already has an SDIO stack; hence the Atheros one is redundant.
> The openmoko people already have a port of their ar6k driver to the
> in-kernel SDIO stack.

Which of course means that one big barrier to including the ar6k driver
is already removed.  You can browse the ar6k openmoko code at:

http://svn.openmoko.org/developers/sameo/patches/ar6k-ng/

Dan

