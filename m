Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab0BEOGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 09:06:41 -0500
Subject: Re: Status of http://patchwork.kernel.org/patch/62072/
From: Johannes Berg <johannes@sipsolutions.net>
To: Jochen Friedrich <jochen@scram.de>
Cc: linux-wireless@vger.kernel.org, gertjan@vanwingerde.net,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
In-Reply-To: <4B6C223F.5070002@scram.de>
References: <4B6C223F.5070002@scram.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DzVXs7vnk+6uFg/2D77j"
Date: Fri, 05 Feb 2010 15:06:38 +0100
Message-ID: <1265378798.3613.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DzVXs7vnk+6uFg/2D77j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-05 at 14:50 +0100, Jochen Friedrich wrote:
> Hi,
>=20
> does anybody know what's the deal with patch http://patchwork.kernel.org/=
patch/62072/ ?

It is rejected and will not be applied.

> On ath5k hardware (WGT634U running OpenWRT Kamikaze with current compat-w=
ireless) this patch is=20
> still needed to avoid these headroom too small messages on WDS links (4ad=
dr frame format).

If ath5k also uses the headroom for alignment then it needs to reserve
more headroom.

johannes

--=-DzVXs7vnk+6uFg/2D77j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbCXrAAoJEODzc/N7+Qma4+kQAIxWeUMt/OHPCprqDCmb5CP6
pPS6HVkSdZa/y6IdHZKjKnPRwKUt5hhb8RI8NR8nhngaR/GiFbXzG/FMjOkvZ0xV
r/qka7xZJ/ONNESRZzf5VIqhJwid4TkGq+CvmO1d/dMhwAgWJRCldBJov0d+Uc1E
/BEgdrFt7qI/vL5WrWv3v13MGXU4GKuqipNisDV+FPjzg3sjqMwQF8hA8h4NcnlG
fy5eVjEsh5WBL2MuGyqRiHYm5XS+xZI0hec/lnwAf3NIS8V5RGz0ytRycTs9dHKP
sbvPodHClB/eQ67VbwSN/fObTWqaiu/RegVnZExrwHu4hympvwvwCuJGEe+9y71l
X3pmSm1MuSc0GSkIZ9Mb18ISts0GvxF11Dd3cx1rMY6GoWgFoszLVQFWj/QnWGDN
fCIMWQszD4meTJ0gAng8ekJDpknl83q321OQ801sohq2fwcPdimtRcr4yRwzwkdI
VA4oWrHNYyZUNl1bzy91EEgKKuXIiXUfBXgpG7qEXE9jcKpUJQOjFYqw6EFfPPBe
kN8PXQtv2i4JEE8m804Av6iiwBKRwVX2ZOVBSmoraK1RLGMdAk/facxbCAqtT2ql
qQCGk/dx3mIHkI7Rs0TIxYJJ7NWcLr24DynijZicdmMurj8OoKdsMdt/jTcTZAXZ
S0uFtHfbSJeVZIdxpHf8
=g7fj
-----END PGP SIGNATURE-----

--=-DzVXs7vnk+6uFg/2D77j--

