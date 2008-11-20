Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYKTT67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 14:58:59 -0500
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1227209360.3766.42.camel@johannes.berg> (sfid-20081120_202928_923853_0C4EBF82)
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811200050u48bc150en34e94c7671672ae6@mail.gmail.com>
	 <f76a32050811200544p3c647cb3t392025feef02c8f9@mail.gmail.com>
	 <200811201537.19047.hs4233@mail.mn-solutions.de>
	 <f76a32050811201121r27ba1d82ma788e5a55bfd422b@mail.gmail.com>
	 (sfid-20081120_202146_459597_36951BC6)  <1227209360.3766.42.camel@johannes.berg>
	 (sfid-20081120_202928_923853_0C4EBF82)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7CKNyj7+8qpmTWGIJEdK"
Date: Thu, 20 Nov 2008 20:58:52 +0100
Message-Id: <1227211132.3766.45.camel@johannes.berg> (sfid-20081120_205902_669418_0B756DF8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7CKNyj7+8qpmTWGIJEdK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-20 at 20:29 +0100, Johannes Berg wrote:

> > @Johannes:
> > I was not able to find any indicated traffic in any of the beacon TIMs.
>=20
> Indeed. But did the problem happen during the trace here? It looks like
> there is no traffic for the ipod between it going to sleep and waking up
> again at all, should there be?

Never mind, I'm stupid, I set wireshark to assume an FCS and then it
didn't dissect things correctly. The TIM bit for AID 1 is set, and since
I guess nothing else is on the network hostapd will have used AID 1 for
the ipod, and the ipod also wakes up.

Therefore, the problem is something else.

johannes

--=-7CKNyj7+8qpmTWGIJEdK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJcF3AAoJEKVg1VMiehFYyv8P/2TJ7pULAKq7nqxZy0Fa5tZB
fLg7QmoRgB6tO+TCkcuBHHEEOuq6c7AqTjptILNm8V2ur2BgCsyeyIIaxt+zqiat
XzNDW7m8Ej13hk+iPShufadxWcCS9r1tZx30VgIRqpvXoJ/lc03KtqDqV0EJ7ZgR
NPTnCzdqf8+lwFrYW+DkO08DUzWjvDoAZEJfbf0t+YnDp4iSptvws8wfQIGRHaTt
3hk7sQshOKTBePl49Jxc5pibI5/P3D4uhRTpVg7pojTckO4HR7KJTas/su+Unmpq
ceVzZL/PHBTRLuZzcqPRe9FZFRqhXHBenKODOCpbLNhR3UyuegcJTMgevgX3bYHW
HxFraP6gB7vov619tJ8yZpyObEYOZu1oKsTVEjAjUm78e1qq+2Env53Bi2OsbpsN
vVCJwBp4PZAIoIzEKxTyC4F/h5JipfXYhwinL3LjwT3Sgl0emGlexHa9gnMtUq4J
kcmIBbKGgmihZMojtvLPwopzDxHbyfHagl/N+AH/PJ9hVF6nWtT+hLsQnME4zp14
1VcfnFNxqSXRD5p+ou/HrG7J6R6iHtgkaflbkMohYtTZTKiy6nJxgiVDenV18uNn
6yeJsUbr0f8UU5fjEsIpPDKBySRxoezG2HPeG2VlMKJGAjZUzYQaNLWw8bnPIrlB
qqG7lSinPhYrJoqTp5pe
=A+7T
-----END PGP SIGNATURE-----

--=-7CKNyj7+8qpmTWGIJEdK--

