Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYLIBH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 20:07:57 -0500
Subject: Re: [RFT] mac80211: clean up set_key callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>, Chr <chunkeey@web.de>,
	Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <20081209010144.GA8828@hash.localnet>
References: <1228757035.22164.94.camel@johannes.berg>
	 <20081209010144.GA8828@hash.localnet>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8LeNlGswjEFDflLlB651"
Date: Tue, 09 Dec 2008 02:07:25 +0100
Message-Id: <1228784845.22164.170.camel@johannes.berg> (sfid-20081209_020800_805523_9FD1EEE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8LeNlGswjEFDflLlB651
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 20:01 -0500, Bob Copeland wrote:
> On Mon, Dec 08, 2008 at 06:23:55PM +0100, Johannes Berg wrote:
> > The set_key callback now seems rather odd, passing a MAC address
> > instead of a station struct, and a local address instead of a
> > vif struct. Change that.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Works here... ath5k changes:
>=20
>     Acked-by: Bob Copeland <me@bobcopeland.com>

Thanks for testing.

> But ath5k probably wants this one-liner too (feel free to just=20
> roll it up into yours):

Right, I'll roll it up so you don't have to resend it.

johannes

--=-8LeNlGswjEFDflLlB651
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPcTJAAoJEKVg1VMiehFYXdQP/je/JrlZEgnLBraLrQwwqEzF
vCXCuKPOCWe2JJs6J0SBko79Moj8dgFzdZXg3RZDg6b5BE/ahsCIV6KZU0lk7Uzm
Yd92ItrUJ/nYffMtAM9byhRk4CCPS49TLKl9WlOLEclXqWmmAA66eDPrb0s6aivc
Ri1g3GDc/eR+zmpoRk8JsfHCs5ilrbdcaB2QsaIap5LtJ8xV3vdCE9dpqiV8gqBZ
J+WTMYhc1LY6Lz/WIENWeYlLWYZBjyN75YCwC4JTWWoS74zj6rG8EM80aJGndyl+
Z9PJt47+c93G3mIP0vR8Zoa6TyYzTWnrZVaxYBP8LR4VZhnuOokZVsQ0+XWPrO0r
O2OMlDnP6giXkGHsALvXNHgTK5I702xJlNuGVwuVoLn7VLEBydg+zjD6lIUSN7CO
qf4d+RCtUXR1ZDko8pKQfKAkEk54qCquc/5lYql4mi853lUjYPyRX56Lif9qKebA
dyOlOhtUZ4NqqZMkGnGIXQYP1vKYgB9LM17nzWLflO4MWTNYENPJSi/+BEyLKJea
LpL3duxzFBLsSFcCSPNkvD+lTBZRTDsPpJxQoQN2bEI6R2FT0wkqyecuNDb5AO7L
UfMRsxWmwkFXB3dXb1A7XGAZ1mfOwea7R06HFpNPC9OeMCiHsj4sXM7yB2VOLd9S
R/6jIHGSZcSasBGbaYC+
=1NvS
-----END PGP SIGNATURE-----

--=-8LeNlGswjEFDflLlB651--

