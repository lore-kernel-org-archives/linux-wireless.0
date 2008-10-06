Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYJFPL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 11:11:28 -0400
Subject: Re: [PATCH 0/4] multi-rate retry and the 'minstrel' rate control
	for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <48E8E48E.5090300@openwrt.org>
References: <48E8E48E.5090300@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bQ+4IPGfR1cLebSRSV7i"
Date: Mon, 06 Oct 2008 17:10:54 +0200
Message-Id: <1223305854.15196.26.camel@johannes.berg> (sfid-20081006_171146_098378_1D2C8A24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bQ+4IPGfR1cLebSRSV7i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-05 at 18:00 +0200, Felix Fietkau wrote:
> Hi,
>=20
> Here are the new patches for multi-rate retry and the minstrel=20
> rate control algorithm (ported from madwifi, mostly rewritten).
> I've successfully tested minstrel on ath5k with and without MRR,
> but it should be suitable for other drivers as well, as long as
> they can set and report the number of tx retries properly.
>=20
> This series replaces my previous MRR patches.

Looks good to me, but I haven't looked at the algorithm in detail.

johannes

--=-bQ+4IPGfR1cLebSRSV7i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6ip7AAoJEKVg1VMiehFYcXQQAI33rEW7TF9XNxk/eiafSWIp
x/jY0dHUybWq2UE7eMJdDZ/DCtVB9W9iPJ8TfQ4YCwUOMNFctf4obuHY1oG3tIrD
og/d+jBVQh06YNnsoDdDWUVGZ0KeyBdivl2wYgoQ8MdB63F2XmdCdAAZ62s+i/SE
KU0zGOmVC05KP192pEXsRI9+QOCTnRIPNKj8HZJjHLHGaGE9tKpQ1Tc8wJtDJS67
GMKaNUGCvWIATe++sqTqM0ruu9kDHMlXBjNYdmddPFNN8Jm7U3bPpTiWsj8lF9xh
Oe2sHUUsDkLV2FP4pgIVPhnFnF9YWKFiSJMJQRk/xdt1BwUv/6hqmc6XG80DJ+VA
uSxYEJvG9Q88judp7PDkCjjxTfuGOvIqKRt2Bn070zH8JxY/LgrdFA+rxV8ujB2U
NInEUklhDiTZdaWhP0JGNHV0FHMT274sgba0z+aiFs4NK2+0haocoPNY+SvsE/ko
aYl70h/GlKQLb4Tpqcacs/9GJKEQZ2C/n+hKIi2nGIe2hXEZflf5eIlTrI6xNOg4
IERJt3gCXRlLSIf2RsGcnP9Vu5NQj6AsW7Or/+OixioFNal22JzHjuyxiRE2NVZN
fIVvblSbgcY0CMCEiJcfvDIn0qG+MJfRLNmsaOWgBgpmftybzUqKFq5xkiJX8rQn
l6JQkvWYyNzuf/SKeAlK
=/qAX
-----END PGP SIGNATURE-----

--=-bQ+4IPGfR1cLebSRSV7i--

