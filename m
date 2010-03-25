Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f188.google.com ([209.85.221.188]:57755 "EHLO
	mail-qy0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab0CYXEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 19:04:51 -0400
Received: by qyk26 with SMTP id 26so6002228qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 16:04:51 -0700 (PDT)
Date: Fri, 26 Mar 2010 00:04:45 +0100
From: nanok <rnanok@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: nanokk@gmx.net, linux-wireless@vger.kernel.org
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
Message-ID: <20100325230445.GB7547@spartakus>
Reply-To: nanokk@gmx.net
References: <4B5CD1FF.4090209@twilightblue.net>
 <loom.20100321T212710-762@post.gmane.org>
 <b6c5339f1003251402sa2faff0m42e1a7fef7356e13@mail.gmail.com>
 <b6c5339f1003251404p624d7f15mae54813453821b33@mail.gmail.com>
 <20100325222400.GA7547@spartakus>
 <b6c5339f1003251544r35b59c8fqf6a9beeaa3264b82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f1003251544r35b59c8fqf6a9beeaa3264b82@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 25, 2010 at 06:44:01PM -0400, Bob Copeland wrote:
> On Thu, Mar 25, 2010 at 6:24 PM, nanok <rnanok@gmail.com> wrote:
> > On Thu, Mar 25, 2010 at 05:04:02PM -0400, Bob Copeland wrote:
> >> On Thu, Mar 25, 2010 at 5:02 PM, Bob Copeland <me@bobcopeland.com> wrote:
> >>
> >> > As you are using debian I have to ask: have you installed
> >> > crda? ?Since 2.6.30 ath5k gained regulatory support which
> >> > may cause certain channels to be disabled.
> >>
> >> By "since 2.6.30" I meant post-2.6.30, sorry for any
> >> confusion.
> >>
> >> --
> >> Bob Copeland %% www.bobcopeland.com
> >>
> >
> > hi Bob,
> >
> > no confusion, it's perfectly clear either way you state it.
> > unfortunately, it's 2.6.3
> > 0 that "works" (not pre-2.6.30), or did you mean since 2.6.30, excluding
> > 2.6.30?
> 
> Right, that is what I tried to correct.  _After_ 2.6.30,
> ath5k began reporting the regdomain from the EEPROM which
> means some channels (13 is a common case) are no longer
> accessible whereas they were before with static reg domains
> and no EEPROM support.  That was the major change in the
> driver.  Most other changes since 2.6.30 were in the
> upper-layers.  I don't recall any changes to crypto in that
> timeframe.
> 
> WRT to the original report, is only WEP causing problems
> (i.e. does WPA work?)
> 
> -- 
> Bob Copeland %% www.bobcopeland.com
> 

wpa works with wpa_supplicant, i haven't tested in a while, but i can as
soon as i get home. plain also works (no encryption). iirc, the original
"plaintif" experienced the same.

to keep things accurate, i have experienced again a lock up (kernel
panick) while i was trying to get the wlan0 up (ath5k), and getting
errors, so now i have switched back to ath-pci (madwifi). there might be
something wrong with my hardware (additionally).

-- 
nanok
