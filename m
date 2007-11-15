Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:10273 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216AbXKOJjZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 04:39:25 -0500
Date: Thu, 15 Nov 2007 10:39:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: Ian Schram <ischram@telenet.be>, Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>, Stephen.Clark@seclark.us,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
Message-ID: <20071115093921.GH638@kernel.dk> (sfid-20071115_093930_457935_9F748F8F)
References: <20071017135452.GJ5043@kernel.dk> <1ba2fa240710180602m61ae9478k84791690095e76d@mail.gmail.com> <473514F3.50500@telenet.be> <200711150253.48628.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200711150253.48628.ismail@pardus.org.tr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 15 2007, Ismail D=F6nmez wrote:
> Saturday 10 November 2007 Tarihinde 04:18:27 yazm????t??:
> > I wonder if anybody knows something more about this issue by now,
> > as it appears to occur to a few people.
> >
> > I reread the thread (rather quickly) but I do not see many specific=
ations
> > of driver/mac80211/kernel. The few cases that do contain specs all =
appear
> > to be using fedora (don't want to jump to conclusions). But just wo=
ndering
> > if anybody experienced this on any other kernel?
>=20
> Btw this is still not fixed in latest git (post rc2).

I'll second that, using todays snap still requires me to do an iwlist
scan before I can use the network.

Is anyone working on this at all? This was reported a month ago, yet no
progress or real developer interest in fixing this is apparent.

--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
