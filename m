Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33831 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390Ab1JHTph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 15:45:37 -0400
Received: by mail-bw0-f54.google.com with SMTP id zs8so10444814bkb.27
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 12:45:36 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: remove warning message during IBSS Tx
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <anamtsov@gmail.com>
Cc: Shahar Lev <shahar@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CA+XVXfd+vN7b=oYrysPCuynAgy5=4SgRHuznJRW0h+6ez7YqsQ@mail.gmail.com>
References: <1318004245-18347-1-git-send-email-shahar@wizery.com>
	 <1318004434.3988.16.camel@jlt3.sipsolutions.net>
	 <CANCvt+6JkxnE6Z7soUuhQSbzpxuxYUNC7z0vv+jn-sH+jpY4Qg@mail.gmail.com>
	 <1318022253.3549.108.camel@cumari>
	 <CA+XVXfd+vN7b=oYrysPCuynAgy5=4SgRHuznJRW0h+6ez7YqsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Oct 2011 22:45:27 +0300
Message-ID: <1318103127.9690.46.camel@cumari> (sfid-20111008_214547_268545_EBF92D48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-08 at 21:19 +0200, Arik Nemtsov wrote: 
> On Fri, Oct 7, 2011 at 23:17, Luciano Coelho <coelho@ti.com> wrote:
> > On Fri, 2011-10-07 at 23:03 +0200, Shahar Lev wrote:
> >> On Fri, Oct 7, 2011 at 6:20 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> > Maybe you should also change that? :-)
> >>
> >> Consider it added to our collective TODO.
> >
> > Well, the fix is probably supposed to be done in mac80211, instead of
> > hiding the bug by removing the warning, isn't it?
> 
> Sometimes data is sent when the IBSS interface is not connected.
> wl12xx handles this correctly by throwing the packets. In this sense
> there's no "bug".
> All this patch does is remove warning messages that confuse the users
> (and developers).
> 
> I agree fixing mac80211 is the better thing to do, and we'll get to it
> when time permits.

Okay, not a big problem to do this in the driver.

But what I meant with "the bug" was that, if this can be avoided in
mac80211, why not do it there? Is it a a big effort to do it in
mac80211?


-- 
Cheers,
Luca.

