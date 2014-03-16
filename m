Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46379 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbaCPSNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2014 14:13:33 -0400
Message-ID: <1394993614.15764.90.camel@deadeye.wl.decadent.org.uk> (sfid-20140316_191336_435938_6A835699)
Subject: Re: pull request: firmware for Intel Wireless adapter 7260 / 3160 -
 22.24.8.0
From: Ben Hutchings <ben@decadent.org.uk>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>
Date: Sun, 16 Mar 2014 18:13:34 +0000
In-Reply-To: <530AF9AE.4000000@gmail.com>
References: <530AF48F.8050802@gmail.com> <530AF9AE.4000000@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Yen8Xkj3SeUGWkni2WjG"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Yen8Xkj3SeUGWkni2WjG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-02-24 at 09:50 +0200, Emmanuel Grumbach wrote:
> Hi Ben,
>=20
> I have a new firmware for 7260 / 3160 - new version is 22.24.8.0.
>=20
> Please pull - thanks!
>=20
> The following changes since commit d7f8a7c81a3aaf06e4166ff17f9ef7cae83191=
6f:
>=20
>   Remove executable permissions from firmware files (2014-01-27 00:49:23 =
+0000)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware =
master
>=20
> for you to fetch changes up to 509a474f31360bce4546046ab037ddad1cc0471a:
>=20
>   iwlwifi: update firmware for 7260 / 3160 devices (2014-02-24 09:19:42 +=
0200)
>=20
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: update firmware for 7260 / 3160 devices
>=20
>  WHENCE               |    6 +++---
>  iwlwifi-3160-8.ucode |  Bin 662032 -> 667284 bytes
>  iwlwifi-7260-8.ucode |  Bin 674628 -> 679780 bytes
>  3 files changed, 3 insertions(+), 3 deletions(-)

Pulled, thanks.  Sorry for the delay.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-Yen8Xkj3SeUGWkni2WjG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUyXpzue/yOyVhhEJAQo31w/+K2urs974jTPt7L/TiNA1QXcxTUsTUJDa
KBQsIageC16Qt+UlOkYiAl5gwwXKBVpCRI1GzT05SAHQ6j+ae+01v07WbXsIkGe9
3NKBw2zo81S5Hp9r9ov6UGI2H7/go7phhvKFip+jpgIC7qGoK9HQb9l7Q0dc8YgT
6KxVHcyYOQi/lbcJcfYQKygs5qO2PEgR9wWHLe2AgyEU7nNJ8TMCZOG6UGwGRPzg
E4DnkHkUeRklFQ4ljYbNroRAEaWVx6/ktKDhoHlda/o8iXKOidQfMbwWZS/OlcXD
qkseCIOFVakLfjfc3moEnO2yRRyhrv3dQvKB9IavmKuv7EUDHeHTocknTrfvBh4w
+k9p7t31EUFGMAxA65cne4FXlBtro0uf8d3kLSdLDECukxnlWLo21bhaCYzcaJJO
wBPiLV//aqGp9UbE9NPXiQrLgahmsxHdgodNIgl0ZeN1nZsXMeB8CroOIIf73mJX
f4fwTOg0zv7XmZWPfHtX90NqVcg4tLQU+LsYnhkBNKTE771SjXTHGBZ8LMUayfEk
p29ARrQnzB/yX7YlFhd9cQeBATM0x7SCJ8bWs+kzk7kRDcXGU/OQ1rRWVWTCaUEi
mqWgCoNyFU0fAFRHCly+41v+a1uCwiOKiBpIgIKq63v6Oo0YPiHMLyaiKTgdsefr
6s5Kgu8LQVs=
=Wkhc
-----END PGP SIGNATURE-----

--=-Yen8Xkj3SeUGWkni2WjG--
