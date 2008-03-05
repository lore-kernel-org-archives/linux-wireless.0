Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2754 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYCESfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 13:35:14 -0500
Date: Wed, 5 Mar 2008 13:11:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	Michael =?iso-8859-1?Q?B=FCker?= <m.bueker@berlin.de>,
	linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: Re: [Rt2400-devel] [PATCH] wireless: rt2x00: fix driver menu
	indenting
Message-ID: <20080305181129.GA6663@tuxdriver.com> (sfid-20080305_183520_719375_D2072EBA)
References: <200802091623.06504.m.bueker@berlin.de> <20080210105252.e0a433ee.randy.dunlap@oracle.com> <200802102003.25392.IvDoorn@gmail.com> <20080304220029.1f152f00.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20080304220029.1f152f00.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 04, 2008 at 10:00:29PM -0800, Randy Dunlap wrote:
> On Sun, 10 Feb 2008 20:03:25 +0100 Ivo van Doorn wrote:
>=20
> > On Sunday 10 February 2008, Randy Dunlap wrote:
> > > On Sat, 9 Feb 2008 16:23:06 +0100 Michael B=FCker wrote:
> > >=20
> > > > 2) When selecting "Ralink driver support" (CONFIG_RT2X00), the =
accompanying=20
> > > > drivers (CONFIG_RT2400PCI, CONFIG_RT61PC, ...) appear unindente=
d. They should=20
> > > > be indented by four spaces.
> > >=20
> > > Yes, patch is below.
> > >=20
> > > ---
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > >=20
> > > Michael B=FCker <m.bueker@berlin.de> reports that the RT2x00 driv=
ers
> > > are not indented as they should be, so use proper dependencies to=
 make
> > > them be indented as expected.
> > >=20
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> >=20
> > Ack-by: Ivo van Doorn <IvDoorn@gmail.com>
> >=20
> > ---
> > John,
> > Could you push this directly into wireless-2.6 and probably upstrea=
m as well.
> >=20
> > Thanks.
> >=20
> > Ivo
>=20
> John, do you have this patch queued somewhere?

It is in net-2.6.26.

commit 0d84d78db5bad848e385cbb1e4ae2ea1f5f27641
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Sun Feb 10 10:52:52 2008 -0800

    wireless: rt2x00: fix driver menu indenting

    Michael B=FCker <m.bueker@berlin.de> reports that the RT2x00 driver=
s
    are not indented as they should be, so use proper dependencies to m=
ake
    them be indented as expected.

    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Ack-by: Ivo van Doorn <IvDoorn@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Hth!

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
