Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:8984 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806AbXKOPPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 10:15:51 -0500
Date: Thu, 15 Nov 2007 16:14:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	Dan Williams <dcbw@redhat.com>, Stephen.Clark@seclark.us,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
Message-ID: <20071115151425.GF5035@kernel.dk> (sfid-20071115_151601_193051_297E9CAC)
References: <20071017135452.GJ5043@kernel.dk> <1ba2fa240710180602m61ae9478k84791690095e76d@mail.gmail.com> <473514F3.50500@telenet.be> <200711150253.48628.ismail@pardus.org.tr> <20071115093921.GH638@kernel.dk> <20071115151046.GA12902@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20071115151046.GA12902@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 15 2007, John W. Linville wrote:
> On Thu, Nov 15, 2007 at 10:39:22AM +0100, Jens Axboe wrote:
> > On Thu, Nov 15 2007, Ismail D=F6nmez wrote:
> > > Saturday 10 November 2007 Tarihinde 04:18:27 yazm????t??:
> > > > I wonder if anybody knows something more about this issue by no=
w,
> > > > as it appears to occur to a few people.
> > > >
> > > > I reread the thread (rather quickly) but I do not see many spec=
ifications
> > > > of driver/mac80211/kernel. The few cases that do contain specs =
all appear
> > > > to be using fedora (don't want to jump to conclusions). But jus=
t wondering
> > > > if anybody experienced this on any other kernel?
> > >=20
> > > Btw this is still not fixed in latest git (post rc2).
> >=20
> > I'll second that, using todays snap still requires me to do an iwli=
st
> > scan before I can use the network.
> >=20
> > Is anyone working on this at all? This was reported a month ago, ye=
t no
> > progress or real developer interest in fixing this is apparent.
>=20
> I don't see any pending patches that seem relevant.  FWIW I'll probab=
ly
> round-up what I do have and make them available today (and probably
> in a Fedora kernel too).
>=20
> Does the disable_hw_scan=3D1 still work for you?  Perhaps we should
> consider making that the default...

disable_hw_scan=3D1 never worked for me - I tried it, and it made no
difference. I _have_ to do an iwlist wlan0 scan before it links with my
access point, otherwise it doesn't work.

--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
