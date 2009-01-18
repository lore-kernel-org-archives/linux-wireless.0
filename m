Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63521 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765997AbZARRjx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 12:39:53 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 09:39:53 -0800
Date: Sun, 18 Jan 2009 09:39:21 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/13] cfg80211: only export disable flag on channel
	disablement
Message-ID: <20090118173921.GZ29609@tesla> (sfid-20090118_183956_116871_93B16D5F)
References: <1232064746-17134-6-git-send-email-lrodriguez@atheros.com> <1232064746-17134-7-git-send-email-lrodriguez@atheros.com> <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> <1232097827.3854.25.camel@johannes> <20090116163245.GF29609@tesla> <1232138101.3745.7.camel@johannes> <20090116210930.GL29609@tesla> <1232268516.3877.10.camel@johannes> <20090118153004.GS29609@tesla> <1232298832.3819.7.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232298832.3819.7.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2009 at 09:13:51AM -0800, Johannes Berg wrote:
> On Sun, 2009-01-18 at 07:30 -0800, Luis R. Rodriguez wrote:
> > On Sun, Jan 18, 2009 at 12:48:36AM -0800, Johannes Berg wrote:
> > > On Fri, 2009-01-16 at 13:09 -0800, Luis R. Rodriguez wrote:
> > > 
> > > > I can put a note, if that helps, or are you strongly opposed to this? :)
> > > > Just an itch to scratch really, have you seen the output of iwlist on
> > > > disabled channels? It can get long on radar/no-ibss channels. We can also
> > > > handle this in userspace but seems pointles if the channels is disabled.
> > > 
> > > Well, come to think of it, at least for programmers it might be
> > > confusing when they know they've put some flag into orig_flags, and then
> > > it disappears? I'm not really _strongly_ opposed to this, but I really
> > > just don't see the point :)
> > 
> > Have you bothered calling iw list with a long list of crap on the channels?
> 
> Heh, no, but I rarely call iw at all. I just added a patch to iw to
> suppress it instead, I think that's more appropriate.

:) alright, fine by me.

  Luis
