Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbYLKWGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 17:06:20 -0500
Subject: Re: [PATCH] ath5k : Fix correct padding
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <200812112258.25007.mb@bu3sch.de> (sfid-20081211_230212_942339_6F33AB66)
References: <49418D23.8060905@free.fr>  <200812112258.25007.mb@bu3sch.de>
	 (sfid-20081211_230212_942339_6F33AB66)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pocwXQJ7IiulXFI0zUcz"
Date: Thu, 11 Dec 2008 23:05:41 +0100
Message-Id: <1229033141.8081.87.camel@johannes.berg> (sfid-20081211_230623_051113_E95EC9BD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pocwXQJ7IiulXFI0zUcz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 22:58 +0100, Michael Buesch wrote:
> On Thursday 11 December 2008 22:58:59 Benoit PAPILLAULT wrote:
> > Padding the 802.11 header to a multiple of 4 bytes needs to be done onl=
y
> > for DATA frames.
>=20
> Uhm, can you explain _why_ it's only needed for data frames?

Well, it's only _needed_ for data frames because the alignment is
something the IP stack needs. That doesn't answer the question, of
course, the answer to that would have to be something like "because the
hardware uses the same algorithm to insert the padding"

johannes

--=-pocwXQJ7IiulXFI0zUcz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQY6yAAoJEKVg1VMiehFYX/MQAKYOvDZ1AllHPcDvOwLYQY8R
25Lv+EfJtxkwEoKWN4+PvbIAGDkm+LxzvyiZuCQS4E1DZLxhUyXCCN8YWuBMtfhI
HCTgdpwUm5G9HzwyIIBXhCDGU200kype1cnZ9z/dquzb8PjRyoOwquCl/ugW2/4P
JFNMzwEu2y1mQxwBghaASH81LqOm+ZcExfW1RrbTanfjZb8VwLL1RLVHKihtRhf/
/qlucygtvB6wOfmKEOzxlXERl2G050toXijSWJf5PBOSCVcl0suU/hsKAwzt2N49
pWMsT9BP8gdWw/Nxafx2NgB4TJvbG918ywVH1E8DcUcGrpiVR2/SoMF1G8pr4cvr
u/7BNIubyvnQ8XekHZP10ZojhM5OqR453aIBwP5YN7Oz4ioM13I64yrTc2cPUWPf
wmhzMIsJhhYVst+9bXl47BhtoTIYdla5O+KL3VcmItPtna2JTl/JHaiyLAlAw5J7
OAcbcU4kr1yVedFm/vmrAD6dnyNsYV9JdkYipTWEZ5g8cSKJbnRrKqy9KaifJ9m5
fiiW+QzDUiRZMFQk1PdvG5i3h34E4xcx+yBMOEF/qncsaGmZRWu0IPTwkji1XLRP
XwCYBjh4GGodAVJesNECPAv4zgE5HcdhRHvRO2Vn9/nB16U6XKMg+ewUsfz6c4NB
VvQVBNNf+go3WTSd7v1H
=y3yg
-----END PGP SIGNATURE-----

--=-pocwXQJ7IiulXFI0zUcz--

