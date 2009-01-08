Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZAHMGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:06:45 -0500
Subject: Re: [PATCHv2 00/16] mac80211: IEEE 802.11w (management frame
	protection)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090108113158.681894124@atheros.com>
References: <20090108113158.681894124@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nfwot1i4cbPWUOjLdEnq"
Date: Thu, 08 Jan 2009 13:07:41 +0100
Message-Id: <1231416461.3687.0.camel@johannes> (sfid-20090108_130649_678568_5B482AE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nfwot1i4cbPWUOjLdEnq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-08 at 13:31 +0200, Jouni Malinen wrote:
> This set of patches adds support for IEEE 802.11w (management frame
> protection) into mac80211. It is up-to-date with the latest IEEE 802.11w
> draft (D7.0) and I do not expect any major changes to IEEE 802.11w
> anymore.
>=20
> This version is ready to be applied into wireless-testing. It is against
> wireless-testing + CSA patch from Sujith + PS patches from Johannes.
>=20
> Differences to PATCH v1:
> - introduce a mechanism for drivers to indicate that they are MFP capable
>   and allow user space programs to figure out whether MFP can be used
> - mark ath9k MFP capable
> - mark mac80211_hwsim MFP capable
> - rebase against PS patches from Johannes (one of them allocated a new
>   driver hw flag that would have conflicted with an allocation for MFP)

Looks all good to me, thanks for doing the flag and rebasing.

For the mac80211 part (haven't looked at ath9k in detail):
Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-nfwot1i4cbPWUOjLdEnq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZeyGAAoJEKVg1VMiehFYAXkP/0Gt/1DIWca6bOnmQ0KfW825
sAtH/3C4Axfuan4xC0lAyJP+RPYyEVjHIwtyKTQnXh5ydmCVnZjlD3nQxuoZlyO9
lEiuX1wobJycnhlHJaDmMPxhVCkt554pmp9QJB/pjGi8b6Blt6Kdkx4iL5l6w+SE
7xhnFccooSLPSXbq/VBU97RDrXBsUlD2aXZOP4TNi6H8PwkOj4n4S1kAk7SIbn3Y
wJjrLyTxhbWOCHiPzjYfw+19jq2k7xvZm+UUxhVQNbEj2l4Zo09LY5KvWCuKjcBR
PmyA5gd3mWHE+31NcLCyfyOSvnnteuiH98cBZCUVkN+LIwoyPVhIqPmur0y/megl
tyzygxbMDJmcEmXHtdjCq5V0BKHUvnOPK9aaqRGhuiQTQGml2Lzrz9MbIIG3rm2A
gjtSpxEwRjeGnbD4xY1v7VG0SwIdSxOgUawWgGOhYsXDY85SaxwfIq7KdM85ySdi
YHrl9oExOTqUplErdb/rgrBXp+qaH6sppylgkX6wrd7e/dtarrr7tqsSyWuhAVTr
tN+yXprNr5wZGweSg484IB4m2pF33BOFh3UMAYOva6TSYAXCFCKFEbLOlU/w6vji
SvdllWaxRw1eWiXmcmSveWqQaUI/sNfl/8uwrkbe2G6XnsBCJh72nuhsLxJNyDt3
r2elRO0TQRbma4p6z0sz
=CEq7
-----END PGP SIGNATURE-----

--=-nfwot1i4cbPWUOjLdEnq--

