Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376Ab0EZHvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 03:51:18 -0400
Subject: Re: Path for fixed channel issue in aircrack-ng suite
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
	 <1274775071.3635.4.camel@jlt3.sipsolutions.net>
	 <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 09:51:15 +0200
Message-ID: <1274860275.3658.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 00:54 +0200, Gábor Stefanik wrote:

> >> -       if (wdev)
> >> -               wdev->channel = chan;
> >> +       wdev = old_wdev;
> >> +       wdev->channel = chan;
> >
> > NACK. That will crash when there really is no interface being passed in.
> >
> > johannes
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Well, the original version already dereferences wdev in "if
> (wdev->iftype...", so the crash is nothing new if it exists.

It has also been fixed since.

johannes


