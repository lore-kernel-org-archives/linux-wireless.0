Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:40497 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760713AbYAaPuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 10:50:17 -0500
Received: by rn-out-0910.google.com with SMTP id i24so681485rng.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2008 07:50:16 -0800 (PST)
Message-ID: <43e72e890801310750o38faf05ckb9977e4e5d6341fa@mail.gmail.com> (sfid-20080131_155024_292675_A6C3BD52)
Date: Thu, 31 Jan 2008 10:50:11 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Port to new bitrate/channel API
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	johannes@sipsolutions.net
In-Reply-To: <40f31dec0801310732q3ac8fb84p875f31e16444c53e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080130183824.GA7676@makis.domain.invalid>
	 <43e72e890801310707u8e29468h3de981c0e3c72c52@mail.gmail.com>
	 <40f31dec0801310732q3ac8fb84p875f31e16444c53e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 31, 2008 10:32 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2008/1/31, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>:
> > On Jan 30, 2008 1:38 PM, Nick Kossifidis <mick@madwifi.org> wrote:
> > > Tested on 5211, 5213+5112, 5213A+2112A and it wors fine.
> > >
> > > Also i figured out a way to process rate vallue found on status descriptors,
> > > it's still buggy but we are getting closer (i think it improved stability a little).
> > >
> > > Changes-licensed-under: 3-clause-BSD
> > > Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> >
> > My approach was little more extreme removing ath5k_rate struct and led
> > stuff completely but well, its not done. Also we definitely still do
> > dependent on mode stuff a lot and the whole capaibilty stuff is used
> > inconsistantly. If anything I can base patches on this work.
> >
>
> I also wanted to make a bigger cleanup (i added some TODOs there about
> removing led stuff -i want to port them to mac80211 leds, not just
> remove- and most of rate tables -we still need rate code mapping-,
> other things can be ripped out also) but until i'm done with the exams
> i don't have much time. Also some cosmetic changes like Jiri noticed
> would be usefull and i intend to do more cleanups on that way also. I
> hope i can come back with more stuff quickly ;-)
>
> > Nick, just please review the license and files you've changed. Other
> > than that it looks OK.
>
> Ouch you are right !
>
> for base.c/base.h
> Changes-licensed-under: 3-clause-BSD
>
> for hw.c/initvals.c/phy.c/ath5k.h
> Changes-licensed-under: ISC

Thanks. Nick as Jiri pointed out, can you also re-send after checking
the patch with checkpatch.pl?

  Luis
