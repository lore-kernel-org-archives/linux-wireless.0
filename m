Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700AbZCaSC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 14:02:27 -0400
Subject: Re: [ipw3945-devel] 2.6.29-wl-36116-g6a982a0: connection loss
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	reinette chatre <reinette.chatre@intel.com>,
	Nico -telmich- Schottelius
	<nico-linux-ipw3945-devel@schottelius.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200903311957.39264.chunkeey@web.de>
References: <20090331044946.GA10616@denkbrett.schottelius.org>
	 <1238520041.5970.112.camel@johannes.local> <8763hpsi0a.fsf@litku.valot.fi>
	 <200903311957.39264.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KuxfCdFxJwjXAM1Pr+QU"
Date: Tue, 31 Mar 2009 20:01:51 +0200
Message-Id: <1238522511.5970.114.camel@johannes.local> (sfid-20090331_200230_540548_8D6F3700)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KuxfCdFxJwjXAM1Pr+QU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 at 19:57 +0200, Christian Lamparter wrote:
> On Tuesday 31 March 2009 19:45:57 Kalle Valo wrote:
> > Johannes Berg <johannes@sipsolutions.net> writes:
> >=20
> > >> Perhaps the new beacon filtering work [1] is changing more than it
> > >> intended?
> > >
> > > I think it only changed the messages here. Previously, that message
> > > simply wouldn't have been there, instead you'd only have seen the "No
> > > ProbeResp from current AP - assume out of range" thing.
> >=20
> > At least I have been using latest wireless-testing with iwl3945 all the=
 time
> > (for example right now) and I haven't noticed any problems.
> >=20
> > But your comment makes me think is the "beacon loss" message too
> > verbose. Maybe we should remove it?
> >=20
> > BTW, what are the AP settings (beacon interval, DTIM)? Was power save
> > enabled in the driver? If the beacon interval is really long, like 1
> > second, our timer is far from optimal and missing beacon only once
> > might trigger the warning. We should fix that properly at some point.
> >=20
> and what is its tsf/last beacon in iwlist wlan0 scan?
>=20
> e.g:
> Extra:tsf=3D0000005a35738ad1
> Extra: Last beacon: 2180ms ago

that would have to be 'iwlist wlan0 scan last' to actually give
something marginally useful.

johannes

--=-KuxfCdFxJwjXAM1Pr+QU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0lqNAAoJEKVg1VMiehFYA90P/RiVPpEtmrlaBF3WgX3GvN5j
JRuDaziBU7Tsyk8NrEMx4yFMe2fIGjgL1dfhtDk8plaCACuLr2g4Ek6Fuzkw1iep
WyYGrzbvJjxgqShgmeK3AkGy/6GZ5V8amN1bMXEfHtwchZpQUzmt1oe2fAlPb8EF
1GmY/O5aqgvfeVdKLDofFcr+BI2rQVI8fRjnRvYXxVaSj7nBzPPBwqBFPsLe0ls6
ytXwHkti5+9xinTqGIbahjh8l57k3W4CB45l2Xw56rXl17MCvbvypCV1vnCrQOfl
gkkaIpgMw+tBU2XSCcA5pannvm6P10pKZkGjrS3akYg+D87vV9cXtA8jcpswxixV
FXlE/uUZbdbKkX2C+dKiIEH3pSpq+gjxuPPBzT1XhYePRa7WrRsum2l1UFNb6SFI
1fgxdgiBGhMJMFTMTu7zO+PKWp/inopjfHmDUBkJBNeDozdSDBH8RcdPWpRerGVx
B+ejnND1O1Opf+UWwZ52Ty/tIN3LxVSS+C06oaG3Bp/C3HUgVB4CZO6iIngjEuoL
4T0KejTySwQaxz2FkdJUCAbcWbf42GiKzuzKXMYNVpp22Wu5P9pw9V4kfxYeqQGm
1BXvouqnUrVM1l2JHG0TgnzHbehUXSdEPhyT6zFH6UBLro+mYuTGGK87Ik+JaYMW
XmikkOjmee2tJVax6jFE
=vD0B
-----END PGP SIGNATURE-----

--=-KuxfCdFxJwjXAM1Pr+QU--

