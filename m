Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbZHUN22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 09:28:28 -0400
Subject: Re: [PATCH] iwlwifi: Make injection of non-broadcast frames work
 again
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910908210621t3e239f09w6a2037e8c37b40ae@mail.gmail.com>
References: <4A8DC955.9060100@gmail.com>
	 <1250842889.13872.8.camel@johannes.local>
	 <69e28c910908210621t3e239f09w6a2037e8c37b40ae@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pARH6Dn9uAyyWZW06epe"
Date: Fri, 21 Aug 2009 15:28:17 +0200
Message-Id: <1250861297.4600.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pARH6Dn9uAyyWZW06epe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 15:21 +0200, G=C3=A1bor Stefanik wrote:

> > And remove the warning in the
> > default case, since that's what happens if in pure monitor mode afaict.
>=20
> From my limited testing, in monitor mode, the vif type will be
> IFTYPE_STATION, so the default case is never hit. (Is this a bug?)

It's the way iwlwifi handles things I guess.

> (BTW now that in mac80211, we internally use IFTYPE_MONITOR in monitor
> mode, as opposed to just checking for a missing STA - why can't we
> propagate this to the drivers, and have a much saner way of informing
> the driver of monitor mode? This is especially a problem for zd1211rw,
> where to get proper monitor mode, ZD_SNIFFER_ON needs to be turned
> on.)

Think about it again (hint: multiple interfaces), and then ask the
question again.

johannes

--=-pARH6Dn9uAyyWZW06epe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjqDtAAoJEODzc/N7+QmatFoP/jAC1DDl31aFaeUBaFQV5R9e
bnGKIFc81mnwPYdpk+g/3+r3ggQCCtGl0301eF90T8MVMSHvgtID1xYH9vldmoSS
R3UaY4j1sJN931ESLZkf7DcLIA7tGdU6tixuC5k70I+/ToHvd4KP4YJVzkpfN23W
alx/ikIeHbPWyweKJleILRvqTbJDZhLFO//2Mk5pf2TcFd7125kTkUfrUnjtawvp
ttnDmMXJ2WICabfyg/n8xr5f+uk9FD8f1DtXFnuwWcEDXCDXo1G6aicz8bNhJak6
wmRMEiJShiejdsM+jbsCvferby5lOh7owRSelz0N/LhnfnS0IzGMtCjUrpomMX8v
LOdJ8EOHdGzJamHDlZ5KyuAa2qd4b8ANXJRgUGAAOE8SJUEDX3h1DkooSQ3JbmbQ
Iw6wtlgisL3bwZulDF/EyNvuRUqAvd3OyZnu0r/PLlKAHbJEd3A7cgohIxNaCzdv
rhJDuj7Wj3lD20wtJ5iqpnRCruQ5dzR//gqBG45aAjcTvWPMBhjWUqXhV9W0vumi
T5af3GYGZsgvgWhf1bofTs+GTGjjiKIbbVxfbgLHMUQ0SLN4QSgmis8pcxxc9Wgw
pHzA3GItIfnJV96nFqwg5H4zJum9JjVv9jAXayRfWQoIXJAZTIj14Eyy4aZ6UWov
tqpI2OwWCnOT5vciLTYK
=gR2H
-----END PGP SIGNATURE-----

--=-pARH6Dn9uAyyWZW06epe--

