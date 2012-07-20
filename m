Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:40784 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab2GTODS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2012 10:03:18 -0400
Date: Fri, 20 Jul 2012 16:03:01 +0200
From: Dominique Martinet <asmadeus@codewreck.org>
To: sheerapthinath <sheerapthinath@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: BCM4313 injection support
Message-ID: <20120720140301.GA17902@nautica> (sfid-20120720_160321_723652_3E8E8764)
References: <CAJuQfSjWuF=APbRTGbQoBi4fzusd_-CNfBrmS2WOoFWJd1A_hg@mail.gmail.com>
 <4FFFEAD3.6070203@broadcom.com>
 <1342171989.4983.2.camel@jlt3.sipsolutions.net>
 <CAJuQfSgm6tjDG8NfO4G4kE2MXyAF=0e7h1EX=BOydxv0rVoi2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJuQfSgm6tjDG8NfO4G4kE2MXyAF=0e7h1EX=BOydxv0rVoi2g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sheerapthinath wrote on Thu, Jul 19, 2012 :
> As for as my hardware is concerned i could not figure out whether
> there is support for injection. I know that the brcmsmac supports only
> the monitoring mode. Since there is only partial support from
> brcmsmac, i would like to patch to support injection.
> Since iam a beginner, i don't know how to start the driver developement.
> Can you please provide some documentation so that it would be helpful
> in my development?

I've got a laptop with a bcm4313 and injection works fairly well since
3.3 iirc, could you doublecheck that it doesn't work? e.g. run
aireplay-ng in test mode maybe.
(As far as I saw patches come in, injection worked off the bat through
mac80211 since they added monitoring mode)

-- 
Dominique Martinet | Asmadeus
