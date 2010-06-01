Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab0FAUTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 16:19:16 -0400
Subject: Re: Path for fixed channel issue in aircrack-ng suite [V2]
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Farina <sidhayn@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4C056476.9090905@gmail.com>
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
	 <1274775071.3635.4.camel@jlt3.sipsolutions.net>
	 <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>
	 <1274860275.3658.0.camel@jlt3.sipsolutions.net>
	 <4C000B68.9000305@gmail.com>  <1275416907.3778.11.camel@maxim-laptop>
	 <1275419973.3634.7.camel@jlt3.sipsolutions.net>
	 <4C056476.9090905@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 22:19:15 +0200
Message-ID: <1275423555.3634.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-01 at 15:50 -0400, Richard Farina wrote:

> > This won't quite work. monitor interfaces are always slaves in the sense
> > that their channel setting never takes precedence over anything, so if
> > you add another interface and do something there, the hardware will
> > happily channel switch away from the monitor channel, but it will still
> > report the old channel here that you set.
> >
> > I have no idea how to _properly_ fix this though, since eventually we'll
> > have a situation where you can have multiple interfaces active on
> > different channels, so that monitors don't have a fixed channel anyway.
> >
> > Maybe this patch is sufficient since it works in the case people care
> > about when they _only_ have a monitor interface, but I think it'd be
> > nicer if it wouldn't report anything in the other cases.
> >
> >   
> Is this a NACK or a "I wish there was a better way to do this but I'll 
> allow it until a better way if found"?

I haven't really made up my mind. I really dislike the reporting of
wrong information though, see my other email.

johannes

