Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbYKVRya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 12:54:30 -0500
Subject: Re: [PATCH] nl80211: Report max TX power in NL80211_BAND_ATTR_FREQS
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081121170130.GA4887@jm.kir.nu>
References: <20081121170130.GA4887@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+lpeTB6bmKJ/sexx3cp7"
Date: Sat, 22 Nov 2008 18:54:24 +0100
Message-Id: <1227376464.3599.20.camel@johannes.berg> (sfid-20081122_185435_960649_736E69E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+lpeTB6bmKJ/sexx3cp7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-21 at 19:01 +0200, Jouni Malinen wrote:
> =20
> +			NLA_PUT_U8(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
> +				   chan->max_power);
> +

I think for consistency we should use the same format that the
regulatory stuff has for NL80211_ATTR_POWER_RULE_MAX_EIRP, i.e. a u32
value with mBm (I think)

johannes

--=-+lpeTB6bmKJ/sexx3cp7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKEdKAAoJEKVg1VMiehFYPj4P/A2rv+yo3R29s2k5E+ZUks3X
+m0dC4RYswOCET8zqj88qT8grwCr5E+HI1ywdAUJpK5KWdUtXUngzhcAlZLYR+TY
sYYRyI6RCuxuT21WWFiF/HY6ZdwA72j/+DJNjlnFGXScxIeRm4G7CLoaVDmRvLwp
DWF/JO18YA/jZT44Bohrli2KesbovtYRg+j55CxhbR38dPDhAGNz+Vqj2MUBmzig
qSv5oCie+/sE0kDQEFhNR1L1S0M6cV5rrQS0GFkBD0wpLhZozEUdz1ZKS4WPVz3i
SchPaeKu50KthMhw171uS8uB0uaO74DMSqItUz4Fqwkl7yZFvvV44Q5AjjTAJ09T
4olFCBo5PZ+62CIOIhGiLbVhl360JEAqTDME8D4MgLkNfIC+iAQFeZBQOemGy/Jh
W3FEwa3BKJjiplD1NWgGYLACiJEViJ3yLFubYye0qYWt2wOVcy3ddsllM4spdrxC
htW9RyV051/jMf28m14wLUEL6JjEjLmLdGgRWTUgN+3KU15DmIkgjaGe3F7TpSQ9
9yPztL7Jwa3MVzD/cGplUcDBPNgDqnG8XOnO2vWL1lVNr8RpggDt9U45ajOR5OzH
H1siNIWoKolktN3NcyMcTm/Pcu/S16pYh7mWZP20npYuWMyDDoqpiCDg8eN5UnAm
iLGJCvENmeCfujNZfWMu
=N6Ua
-----END PGP SIGNATURE-----

--=-+lpeTB6bmKJ/sexx3cp7--

