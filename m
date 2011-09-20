Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab1ITMNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 08:13:21 -0400
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEfxr6T6LyBOkmoYHKo5GfAAN_=JTK3au=LvzsPxsVJbLA@mail.gmail.com> (sfid-20110919_180134_090871_3D4204A5)
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	 <1316408970.2157.9.camel@cumari>
	 <1316433905.5995.4.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfxr6T6LyBOkmoYHKo5GfAAN_=JTK3au=LvzsPxsVJbLA@mail.gmail.com>
	 (sfid-20110919_180134_090871_3D4204A5)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 14:13:11 +0200
Message-ID: <1316520791.3953.18.camel@jlt3.sipsolutions.net> (sfid-20110920_141334_421688_1596FEAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-19 at 19:01 +0300, Eliad Peller wrote:

> > Yeah it's a good question ... but in this case there actually is some
> > actual reason for it -- I think it's probably used for BT coexist?
> > Obviously the user can't make an informed choice in that scenario, but
> > the device might actually be able to? My biggest objection back then was
> > that the user has no real reason to play with it, and the latency
> > properties of it are better done in other ways.
> >
> i agree.
> however, note that the network_latency can only set the dynamic ps
> on/off. it can't control the timeout.

Oh, I thought it also controlled the timeout -- I seem to remember at
least discussing that back when this got added...

johannes


