Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:38940 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932191AbaCSJfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 05:35:20 -0400
Message-ID: <1395221690.2854.2.camel@dubbel> (sfid-20140319_103524_096043_93A1D7F6)
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 19 Mar 2014 11:34:50 +0200
In-Reply-To: <CAB3XZEfb4Vh29-f-vkRY8--UUyN5cHR_nKy+AW_dVFWGXpE25A@mail.gmail.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <CAB3XZEfb4Vh29-f-vkRY8--UUyN5cHR_nKy+AW_dVFWGXpE25A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [RFC 00/21] cfg80211/mac80211: multi-vif csa
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-18 at 17:52 +0200, Eliad Peller wrote:
> hi,
> 
> On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> > I'm aware this is rather huge. I'm hoping I can
> > get some early feedback before all other patches
> > I'm depending on are finally merged into
> > mac80211-next.
> >
> > Considering current dependency hell of all related
> > the patchsets I'm duplicating some of my patches
> > I've posted on the mailing list here. Hopefully
> > this is sane enough for reviewing purposes.
> >
> > The patchset alone is based on:
> >  * mac80211-next/master
> >  * VLAN chanctx copy refactor
> >  * Luca's intf combination patches
> >  * Luca's chanctx reservation patches
> >
> it could be nice to have some unified branch somewhere with all these
> patchsets. :)
> (i tried doing it locally, but encountered merging errors)

I have created a repo in git.kernel.org for us, based on
mac80211-next.git.  There's nothing there yet, but I'll start populating
it with our patches soon.

git://git.kernel.org/pub/scm/linux/kernel/git/luca/mac80211-next-csa.git

--
Cheers,
Luca.

