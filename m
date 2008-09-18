Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYIRSOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:14:30 -0400
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200809182006.58620.IvDoorn@gmail.com> (sfid-20080918_200703_023992_1E2D0C69)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net>
	 <200809181952.15770.IvDoorn@gmail.com>
	 <1221760449.9262.96.camel@johannes.berg>
	 <200809182006.58620.IvDoorn@gmail.com>
	 (sfid-20080918_200703_023992_1E2D0C69)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eH5XxzepH8qRiK/0x7T6"
Date: Thu, 18 Sep 2008 20:13:46 +0200
Message-Id: <1221761626.20772.0.camel@johannes.berg> (sfid-20080918_201434_323193_919282A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eH5XxzepH8qRiK/0x7T6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 20:06 +0200, Ivo van Doorn wrote:
> On Thursday 18 September 2008, Johannes Berg wrote:
> > On Thu, 2008-09-18 at 19:52 +0200, Ivo van Doorn wrote:
> >=20
> > > From rfkill.h:
> > > 	RFKILL_STATE_SOFT_BLOCKED =3D 0,	/* Radio output blocked */
> > > 	RFKILL_STATE_UNBLOCKED    =3D 1,	/* Radio output allowed */
> > > 	RFKILL_STATE_HARD_BLOCKED =3D 2,	/* Output blocked, non-overrideable=
 */
> > >=20
> > > Since b43 has a rfkill mechanism that does switch of the radio when R=
FKILL is set to BLOCK
> > > after a key press, it should send RFKILL_STATE_HARD_BLOCKED because r=
fkill cannot override
> > > it.
> > >=20
> > > rt2x00 hardware does not change the radio state when RFKILL is set to=
 BLOCK after a key press,
> > > the state is therefor overridable and it can send RFKILL_STATE_SOFT_B=
LOCKED to rfkill.
> >=20
> > If rt2x00 has no meaning of "hardware blocked", why is the button not a
> > simple input device?
>=20
> Because I had that discussion with Henrique and that ended with a "it isn=
't a input device"...

Why isn't it? If it doesn't affect the hardware itself it might as well
be connected to the ps/2 port for all I care.

johannes

--=-eH5XxzepH8qRiK/0x7T6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0ppWAAoJEKVg1VMiehFYEgIP/0Y+TtcHUfSMyH3pJSIj4oh1
ukuURiPOfFZkUIVk35jW5X5zzY/aPQTQltVoV3PlV50Xt66B84V/SXD9/HzVq0P+
eSnyrvuOX/bUh0WVLAstXL1G5M984amokjBPYpsoDZ8fqfbp3x5QEjBMBvPoJMMm
sMC2HO/hQ9/IvY4otVbmqk9FFt3rYjhEPtqzRttQkS9jBTiEZZMiPCR1I2WLecti
1H83Zwqv9Bf0zukIVz1Xu+Z5REIWJU/WAf7/8O8EeUnOXjY7XMoR+GuzlIymCXQw
KsWU4gxrBwt2SSZDjf9WWQLtxvzohGW1eFHvDpK0MLYofaRBjsqJSSgFimmjpiS4
mQwkZmKMaSAtMTz7X0xjrxctD0Eg1Qy1Tp04zgxxiXBk+l1h1Gsynp0QLHzT3spa
YcafrKQz5jHeb1/siETggq/0Ld/Aw0IN61x1kI0zRG3oVcOJBLgFaiUVohskLclC
ZMVEeJOR15kRTykTJB0o64ofYALP5c5EvIZxr7dLeEwola6IphhRrourDq2/Dur3
umhFXjhuI/FmvF9/xA3GEtJO0iClmo1uY0O3XTpzCeg2CYIwDobCwsDg26X+ahGX
Ul54S3YVIWCYKkQ8k/yhEkXc8+5ZJNgErgEeedeLxJwxYz8IaIGCgg3TIeSZh/RT
mJDnQcvsoTiw1sCPxF5w
=z2yE
-----END PGP SIGNATURE-----

--=-eH5XxzepH8qRiK/0x7T6--

