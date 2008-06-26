Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYFZSiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:38:22 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	cs010101@gmail.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1214505366.18729.4.camel@dv>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <200806261821.31643.mb@bu3sch.de> <1214498071.30722.22.camel@dv>
	 <200806261846.17962.mb@bu3sch.de>  <1214501000.3783.0.camel@johannes.berg>
	 <1214503403.18039.6.camel@dv>  <1214503739.3783.14.camel@johannes.berg>
	 <1214504288.18039.12.camel@dv>  <1214504482.3783.20.camel@johannes.berg>
	 (sfid-20080626_202226_010344_A79E9A49)  <1214504874.3783.25.camel@johannes.berg>
	 <1214505366.18729.4.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nAUR9zJlL9x9C74sYdXQ"
Date: Thu, 26 Jun 2008 20:37:37 +0200
Message-Id: <1214505458.3783.30.camel@johannes.berg> (sfid-20080626_203825_193480_A9E2B9AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nAUR9zJlL9x9C74sYdXQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-26 at 14:36 -0400, Pavel Roskin wrote:
> On Thu, 2008-06-26 at 20:27 +0200, Johannes Berg wrote:
> > > > > The fact that we cannot limit the rate like that that?
> > > >=20
> > > > That shouldn't be hard to implement.
> > >=20
> > > Go ahead and post patches then.
> >=20
> > Mind you, I'm thinking of patches that actually address hostapd's
> > incapability of setting rates to use/basic rates etc. in the kernel, no=
t
> > a two-line workaround that only enables 1mbit for AP mode interfaces.
>=20
> OK, I won't interfere with your efforts.

I'm not doing anything at the moment, and don't plan to in the
foreseeable future. (Right now I can foresee about half a year.)

johannes

--=-nAUR9zJlL9x9C74sYdXQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIY+HuAAoJEKVg1VMiehFYIxsP/2dNWp7D5PmFVu752izwv6kJ
SWI79B3Ui0wj0te4ilnhBFwG7UBL7ADOzL6hAh/6SvZMXivPBb3GBBwEkaAKhIzY
UwNePMrEcq9WFoRu1m/j5Z44shnq5jGKO4NUGPNoPUBhgepL7Gw7FrbU9BhFUlPK
dFvJCV89BrwDA3B7Ub1g8I4cWsYMfcQ0Vg88d1tinkyvQVyOWEtLYULM3UcrIdVA
GoF97EBMVV6Yx2+0RgGIw+ScRPCPwfjIVV50v+SqvlbM42z4hLuS7PJNY9mSBWQL
Bz4+T0ItiOLeWhBHsfXF0mPw8nZVr+hYLwjOto76saNK2LwKvKPH2MLMKaAxFISj
WVjr/XHbNdWgA0YTD4uNMF+2t+WRlkDCZB5yNycii6xgRY2HhrZX4NXnOcq4Y5UN
6kbdsk3rX02ZSLjjeKRMnWp3Ot9Z51A9VMKp1nL9l0RZGlJ4RoB+adsv1W7+86sO
++FJ3XRn69ZHAV5bUp8EFjHPZ0GNb3qwzGR0YX7LKR/KWraX36AvKgsHE2rQU9nI
I5qlpT/ARau0NVZpSIMB7esj1601MhFlEgS0UzWhkmjoOIeeL27CjdKaBGMqj3iu
bGdxG8pq1NcxcCk61atyjuaeh+1+yHX3/r5lZf680t/AsbC5FgwTtIr5YJrG0pVO
AT07sM/hcRuWGxm+JiJG
=Z+uP
-----END PGP SIGNATURE-----

--=-nAUR9zJlL9x9C74sYdXQ--

