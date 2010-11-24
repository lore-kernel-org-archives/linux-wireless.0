Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:48454 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754443Ab0KXBeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 20:34:36 -0500
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0523782475
	for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 10:34:35 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 12/30] ath5k: Increase PHY settling parameters for turo mode
Date: Wed, 24 Nov 2010 10:34:37 +0900
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org
References: <20101123190359.GL4303@makis.mantri> <20101123192119.GP29396@tux> <AANLkTi=XpQ1anhSHSoHFFsWPB73zhdqevL7hVvgADOK6@mail.gmail.com>
In-Reply-To: <AANLkTi=XpQ1anhSHSoHFFsWPB73zhdqevL7hVvgADOK6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011241034.37429.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed November 24 2010 05:11:57 Nick Kossifidis wrote:
> 2010/11/23 Luis R. Rodriguez <lrodriguez@atheros.com>:
> > On Tue, Nov 23, 2010 at 11:04:43AM -0800, Nick Kossifidis wrote:
> > 
> > Are you willing to deal with *all* bug reports for this?
> > 
> >  Luis
> 
> I don't enable 5/10/40MHz operation anywhere for now, it's just there
> for testing/debug. I tested it and it seems to work fine (also with a
> spectrum analyzer) but until we come up with the proper way to set
> this from user-space I'll wait. Also have in mind I just do what
> Atheros does on initvals, nothing new, I just diffed initvals/rfbuffer
> settings between turbo/non-turbo modes, found what's changing and how
> (i had 5/10MHz code from HAL for that -as i wrote on another mail
> 5/10/40MHz work mostly the same way-) and implemented it on code. Now
> it's much cleaner + it actually works so i don't see a problem with
> that. Before we had code for turbo that didn't work and duplicated
> arrays of initvals/rfbuffer settings for no reason.
> 
> Have in mind that there are people out there that want 5/10MHz support
> badly to implement 802.11p on top of it (or for research) and people
> who want to get rid of MadWiFi on OpenWRT and use turbo mode with
> ath5k. We had to do this sometime, it's not a dirty hack, i think the
> implementation is clean and simple.
> 
> As for bug reports we already have bug reports about cards that fail
> to wake up that we are unable to debug because we have no idea what's
> going on, you can't choose what you 'll do based on possible bug
> reports, bugs are part of the process...

Hey Nick!

It's great to see that patch series! Glad you're back...
I'll look at the individual patches later, but it's a lot - as you know ;)

bruno
