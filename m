Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab0BQNgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 08:36:39 -0500
Subject: Re: [RFC PATCH] nl80211: add power save commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <1266413252.4524.8.camel@jlt3.sipsolutions.net>
References: <20100216201026.25148.40799.stgit@tikku>
	 <201002170835.00109.holgerschurig@gmail.com>
	 <1266395616.4006.1.camel@jlt3.sipsolutions.net>
	 <201002171421.52329.holgerschurig@gmail.com>
	 <1266413252.4524.8.camel@jlt3.sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kNRDA2+wjOGH/I9Tc5jT"
Date: Wed, 17 Feb 2010 14:36:36 +0100
Message-ID: <1266413796.15836.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kNRDA2+wjOGH/I9Tc5jT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-02-17 at 14:27 +0100, Johannes Berg wrote:
> On Wed, 2010-02-17 at 14:21 +0100, Holger Schurig wrote:
> > > But if you wish you can emulate that with rate mask settings.
> > > Not in cfg80211 though please.
> >=20
> > No, modulaton !=3D rates.
> >=20
> > AFAIK you can run 1 MB/s with both CCK (802.11b) and with OFDM=20
> > (802.11g), but they generate different wave-forms.
>=20
> No.

Well I should qualify. 1 Mbit isn't CCK, it's DSSS. 5.5 and 11 are CCK,
or optionally PBCC, but I've seen exactly one AP that might support this
(indicated by supporting 22 Mbit, but not 33).

In practice, the only supported rates at least in mac80211 right now are

DSSS: 1 2
CCK: 5.5 11
OFDM: 6 9 ...

The supported preambles would be ERP and DSSS on 2.4 GHz, and OFDM (does
that preamble even have a specific name?) on 5 GHz, I think.

johannes

--=-kNRDA2+wjOGH/I9Tc5jT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLe/DhAAoJEODzc/N7+QmaQUcQAKZu9/zlGwEOhzvGXBkXYVIl
cmIh9dPTHjVnbNVresWgz1+w6LKaaMv8fvutuaGbbnE+mxoQipTVCeS0zYlU8hQS
ayL/CwJQyeo60djIqWj+6cPPXk0EHqqipGrGsdTF2Zfez01jivgv5E2dTYdS03wq
GKhWLoc87+U1HU2Bhtm8qDr3SvxhXn4zSbpnxLq8aPT1+VJlHoThnjdpAE7+HS/w
0x5XTc5ul++FoG3z1nsJyoQbR9+2V0IdAa2BSCw2D+1/l4buUo8nB5zquyGXq3j1
wbKG4SancYRWf/vPSJWieXRtVtJ7FhbhyPDpgVnmYn/tDCfPUz6gKnh2GeY88OWi
bBPdHGInwkkA901AEm5LtjMFA4+NHaYHQRn1JKCIK2AxE8n7DoBL9c+HSzLy69WU
fMCetzkKEd5e+Xoe3J+hi/ZvIDwCsER/AWaSC98CCgoJf6GhtryOsdaODYTnZcYB
kJKhjEe9N/m1ChVLIOC7XP85gbmBGKtdxCjkG28rwUur6V7YB42Vve0ho38lT0/7
9H1qk1zp3q41nE9AMJH8NhZ3ONTku7vdLfY8475sXYUMyunKABpt/nuV5w3cDwMA
+4QcS2pP/+4xhfPDpaHOrmOcWGeEBmOw+kr2EgR1UkICMd49UKF9y3P/P8Kmt0vT
QVJ5zueeuoTPMhxWCJGv
=gi6v
-----END PGP SIGNATURE-----

--=-kNRDA2+wjOGH/I9Tc5jT--

