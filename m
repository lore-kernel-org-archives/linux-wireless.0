Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:57505 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaAVJJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:09:10 -0500
Message-ID: <1390381747.4189.5.camel@porter.coelho.fi> (sfid-20140122_100915_408339_DB1E5D89)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 11:09:07 +0200
In-Reply-To: <1390381261.4334.12.camel@jlt4.sipsolutions.net>
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	 <1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
	 <1390318236.6199.45.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ==WJPJV=t8=_CZAD5qyW3igAtaOcUz9hNCcvUPYH+jdA@mail.gmail.com>
	 (sfid-20140122_095414_681765_24CF21EF) <1390381261.4334.12.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 10:01 +0100, Johannes Berg wrote:
> On Wed, 2014-01-22 at 09:54 +0100, Michal Kazior wrote:
> > > I'd say Luca's approach has more future, as it makes channel context
> > > support native. With this, I don't even see how you *could* later add
> > > real channel context support. A function like this, that essentially
> > > assumes exactly a single chanctx that might be doing CSA and similar
> > > seems to make that rather difficult.
> > 
> > I'm not really aware of Luca's work.
> 
> I guess he should post it :)

Yes, I have an internal patch that I wrote last year as a proof of
concept.  I have cut some corners (eg. the non-chanctx case Johannes
mentioned), so I need to rework it a bit before posting here.


> > > In any case, unless I'm missing some bigger picture this seems like a
> > > really hacky way to add things, basically ignoring all the channel
> > > context work. Since I care more about channel contexts, maybe we should
> > > merge support for channel context CSA before we try to do the multi
> > > thing.
> > 
> > This is, I assume, Luca's work you're talking about here again. What's
> > the progress on this? Any time estimates?
> 
> I think he has patches but they break the non-chanctx case right now...

I'll post the patch (as an early RFC) and explain the concept as soon as
I manage to catch up with Michal's patches and all the discussions. ;)

--
Cheers,
Luca.

