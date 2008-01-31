Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:48096 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYAaPcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 10:32:01 -0500
Received: by an-out-0708.google.com with SMTP id d31so168856and.103
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2008 07:32:00 -0800 (PST)
Message-ID: <40f31dec0801310732q3ac8fb84p875f31e16444c53e@mail.gmail.com> (sfid-20080131_153207_884302_4F2FA9D0)
Date: Thu, 31 Jan 2008 17:32:00 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Port to new bitrate/channel API
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com, johannes@sipsolutions.net
In-Reply-To: <43e72e890801310707u8e29468h3de981c0e3c72c52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080130183824.GA7676@makis.domain.invalid>
	 <43e72e890801310707u8e29468h3de981c0e3c72c52@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/31, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>:
> On Jan 30, 2008 1:38 PM, Nick Kossifidis <mick@madwifi.org> wrote:
> > Tested on 5211, 5213+5112, 5213A+2112A and it wors fine.
> >
> > Also i figured out a way to process rate vallue found on status descriptors,
> > it's still buggy but we are getting closer (i think it improved stability a little).
> >
> > Changes-licensed-under: 3-clause-BSD
> > Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> My approach was little more extreme removing ath5k_rate struct and led
> stuff completely but well, its not done. Also we definitely still do
> dependent on mode stuff a lot and the whole capaibilty stuff is used
> inconsistantly. If anything I can base patches on this work.
>

I also wanted to make a bigger cleanup (i added some TODOs there about
removing led stuff -i want to port them to mac80211 leds, not just
remove- and most of rate tables -we still need rate code mapping-,
other things can be ripped out also) but until i'm done with the exams
i don't have much time. Also some cosmetic changes like Jiri noticed
would be usefull and i intend to do more cleanups on that way also. I
hope i can come back with more stuff quickly ;-)

> Nick, just please review the license and files you've changed. Other
> than that it looks OK.

Ouch you are right !

for base.c/base.h
Changes-licensed-under: 3-clause-BSD

for hw.c/initvals.c/phy.c/ath5k.h
Changes-licensed-under: ISC

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
