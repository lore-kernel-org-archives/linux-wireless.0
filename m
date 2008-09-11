Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52568 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYIKR02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 13:26:28 -0400
Date: Thu, 11 Sep 2008 13:24:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Anna Neal <anna@cozybit.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: Improvements on automatic tx power control
	via SIOCSIWTXPOW.
Message-ID: <20080911172406.GG3423@tuxdriver.com> (sfid-20080911_192632_851371_34725339)
References: <48c86ed3.16be600a.2bc8.4c4e@mx.google.com> <1221147299.771.24.camel@localhost.localdomain> <aa050c750809111003i77e8fb3flc68424e7c81a97c2@mail.gmail.com> <aa050c750809111013r4c941ed4l250c5ae5e019c720@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <aa050c750809111013r4c941ed4l250c5ae5e019c720@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2008 at 10:13:20AM -0700, Anna Neal wrote:
> On Thu, Sep 11, 2008 at 10:03 AM, Anna Neal <anna@cozybit.com> wrote:
> > On Thu, Sep 11, 2008 at 8:34 AM, Dan Williams <dcbw@redhat.com> wrote:
> >> On Wed, 2008-09-10 at 16:45 -0700, Anna Neal wrote:
> >>> Improved the tx power control configuration per Dan Williams suggestions. Added
> >>> a firmware version check because the current implementation will only work for
> >>> below version 9.
> >>>
> >>> Signed-off-by: Anna Neal <anna@cozybit.com>
> >>
> >> One more round, sorry! :)
> >>
> >> First, until the patch has actually been applied, could you post
> >> complete diffs?  This is a patch against the previous patch, but it's
> >> best to keep the whole patch together until it's committed by John to
> >> the master wireless tree.
> >>
> >> Second, since you get to respin the patch anyway for this, the TPC
> >> Config stuff should be just fine on V9+ firmware, only the
> >> POWER_ADAPT_CFG command is incompatible on V9+.  I probably wasn't clear
> >> enough about this yesterday.  Any chance you could move the TPC config
> >> commands out of the firmware check and just the PACFG ones < V9?
> >>
> >> Thanks!
> >> Dan
> >
> > No problem, will send a new patch later today.
> >
> > I just wanted to point out that it seems the original patch was
> > already committed by John.
> >
> > Here is the link:
> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commith=cdd799f13e3a2a47b501286551ba9386e8936272
> >
> > Thanks,
> > Anna
> 
> I'm sorry, I sent a bad link.
> 
> Here is a good one.
> 
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit&h=cdd799f13e3a2a47b501286551ba9386e8936272

FWIW, it hasn't been sent to Dave M. yet -- it's only in
wireless-testing.

That said, I'm fine with either a whole new patch or the incremental
one.  But if Dan wants a new one and you don't mind...

John
-- 
John W. Linville
linville@tuxdriver.com
