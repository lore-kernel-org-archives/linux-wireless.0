Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:44954 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919Ab1DAQaU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:30:20 -0400
Subject: Re: ChipCommon as independent driver?
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <BANLkTikR3DjQ1LbU47zrm+zV3sqW37bzrA@mail.gmail.com> (sfid-20110401_182157_154317_212E1805)
References: <AANLkTikGp+ZFhTtsaW7E4SO_5trte1_eF4KLWbkwVty5@mail.gmail.com>
	 <1301673646.5219.18.camel@maggie>
	 <BANLkTin2ZaBVbum9Y=iqWTwW4kzkdKAJnA@mail.gmail.com>
	 <1301674530.5219.25.camel@maggie>
	 <BANLkTikR3DjQ1LbU47zrm+zV3sqW37bzrA@mail.gmail.com>
	 (sfid-20110401_182157_154317_212E1805)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 18:30:15 +0200
Message-ID: <1301675415.5219.27.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 18:21 +0200, Rafał Miłecki wrote: 
> W dniu 1 kwietnia 2011 18:15 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> > On Fri, 2011-04-01 at 18:06 +0200, Rafał Miłecki wrote:
> >> W dniu 1 kwietnia 2011 18:00 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> >> > On Fri, 2011-04-01 at 16:49 +0200, Rafał Miłecki wrote:
> >> >> Do you have idea how we could nicely solve that issue?
> >> >
> >> > Yeah. Just don't share code between ssb and bcmai.
> >> > That's the only clean solution to that mess.
> >>
> >> Do you want to have core drivers separated as well? Really? Should we
> >> have separated pci core? chiccommon core?
> >
> > Yes. Those "drivers" are a mess full of ssb specific workarounds
> > to hardware limitations.
> 
> I really don't understand what you meant in:
> 
> 2011/2/18 Michael Büsch <mb@bu3sch.de>:
> > Note that this does not mean that we need to duplicate the MIPS,
> > common and probably pci core drivers. A hybrid module can be done,
> > if that's desired to avoid code duplication.
> 
> then :|

_can_ be done.
That doesn't mean it must be done or whether it's a good idea to do so.

It certainly is possible to do so, but I don't think it makes
a lot of sense.

-- 
Greetings Michael.

