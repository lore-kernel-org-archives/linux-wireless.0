Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2628 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbYC1Ux2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 16:53:28 -0400
Date: Fri, 28 Mar 2008 16:32:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless mini-summit agenda proposals?
Message-ID: <20080328203246.GB810@tuxdriver.com> (sfid-20080328_205330_701058_DBCD9FFA)
References: <20080131162514.GC6413@tuxdriver.com> <1201801923.3000.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1201801923.3000.13.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Excuse the top-posting...this isn't really a reply to Dan, but I
wanted to remind everyone of his agenda suggestions...)

I'm sorry I didn't find-out sooner (apparently there was an email
delivery problem of some sort), but we got approved for a mini-summit
just before OLS in July:

	http://www.linuxsymposium.org/2008/minisummits.php

This location is reasonably convenient for both North America and
Europe, and many people attend the OLS event anyway.  Are there any
major objections to this venue?

I'm sure some people will need some help with funds for attending.
I don't have any budget for such things, but if you are in need of
assistance and believe your attendance to be necessary or beneficial
then let me know -- I'll see if I can scratch-up some funds from
somewhere.

Any comments?

John

On Thu, Jan 31, 2008 at 12:52:03PM -0500, Dan Williams wrote:
> On Thu, 2008-01-31 at 11:25 -0500, John W. Linville wrote:
> > Greetings,
> > 
> > It looks as if we have a few venue options for a third wireless summit.
> > While this may seem like a luxury, none of the options are perfect
> > for everyone and each has it's own potential drawbacks.  So rather
> > than move blindly forward with any given venue, I think it would be
> > good to discuss some potential agenda points.
> > 
> > This will serve both to determine who is most interested in attending
> > a summit and who might most need to be there.  This will also serve
> > to justify the trouble of having a summit at all.  So, I'd like to
> > open the 'floor' to discussion proposals.
> > 
> > What discussions pertinent to Linux wireless development do
> > you want to see?  What can you contribute to those discussions?
> > How would a face-to-face discussion of that issue be better than an
> > online discussion?
> 
> cfg80211/nl80211 - overview, get Johannes to disseminate knowledge
> because email isn't optimal for this.  I haven't had enough time to jump
> into it yet, but the fact that Johannes is the vast majority of the
> effort here is worrisome.  Having a reference implementation (airo,
> atmel, maybe libertas) of a fullmac driver ported to cfg80211 would
> probably be very useful, even just to get a sense of how the API works.
> 
> rfkill - how to clean up the mess, including how it's all supposed to
> work from userspace with kernel bits, ACPI bits, vendor modules like
> asus_acpi and dellWirelessCtl, input-only buttons, etc
> 
> WiMAX - what hardware is coming, what the APIs should look like (OMA-DM
> is likely to be part of Sprint's stack for XOHM), what the driver
> situation is, and how to fend off a repeat of the 802.11 regulatory
> situation for WiMAX (most parts are apparently fullmac right now, but
> softmac will surely come).
> 
> 802.11s - nail down issues that Javier/Luis/others might have and try to
> push the 802.11s mesh stack forward (driver issues, API issues, etc)
> 
> 802.11n - do we need any discussion here or is it just a question of
> executing on the current plan?
> 
> Userspace MLME - what's going on here?  Noise around this seems to be
> quieter these days.  Is stuff going according to plan/schedule or are
> there roadblocks?
> 
> lib80211/fullmac - maybe this just needs to be picked up and done by
> somebody and doesn't need any discussion or whatever
> 
> Dan
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
John W. Linville
linville@tuxdriver.com
