Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16598 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZE0Afx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 20:35:53 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 17:35:55 -0700
Date: Tue, 26 May 2009 17:36:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	=?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@Atheros.com>
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
Message-ID: <20090527003600.GL9370@tesla>
References: <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com> <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com> <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com> <3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com> <20090407160812.GA5758@tesla> <3ace41890905250008q255d15dej45a4f53d9f8c90e4@mail.gmail.com> <20090526163013.GA7072@tesla> <69e28c910905261227o7bbf81c8jbc5014792acb3af8@mail.gmail.com> <1243377395.23825.0.camel@johannes.local> <3ace41890905261719k3565da39v360adf1e0ff2d270@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <3ace41890905261719k3565da39v360adf1e0ff2d270@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2009 at 05:19:49PM -0700, Hin-Tak Leung wrote:
> 2009/5/26 Johannes Berg <johannes@sipsolutions.net>:
> > On Tue, 2009-05-26 at 21:27 +0200, Gábor Stefanik wrote:
> >
> >> AFAIK the developers will never accept any AP mode for zd1211 devices,
> >> as it has no multicast buffering feature in the hardware. (The vendor
> >> driver, as well as the Windows driver implements AP mode with a spec
> >> violation to get around the lack of a multicast buffer.)
> >> CCing Johannes, he was the one who initially said that.
> >
> > Pretty much exactly it.
> 
> I think what I meant is, what else is needed for AP mode from mac80211
> ? Or is it 'never'?

Not going to happen.

  Luis
