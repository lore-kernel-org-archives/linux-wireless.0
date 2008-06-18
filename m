Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYFRKIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 06:08:44 -0400
Subject: RE: [PATCH] iwl3945: use rfkill subsystem
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
Cc: drago01 <drago01@gmail.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <BD524EA7912ED5469DFD0BAEF6BC752F03D2C277@orsmsx411.amr.corp.intel.com> (sfid-20080618_043443_860797_0713FE4A)
References: <f6ca9fed0806160059l58286050wfeb6eda938f3a171@mail.gmail.com>
	 <BD524EA7912ED5469DFD0BAEF6BC752F03D2C277@orsmsx411.amr.corp.intel.com>
	 (sfid-20080618_043443_860797_0713FE4A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9RmZwegzYkOievkj6PkK"
Date: Wed, 18 Jun 2008 12:07:54 +0200
Message-Id: <1213783675.1312.6.camel@johannes.berg> (sfid-20080618_120847_883237_785CB4A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9RmZwegzYkOievkj6PkK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-17 at 19:34 -0700, Kolekar, Abhijeet wrote:
> Added clearing the STATUS_EXIT_PENDING bit while ifup.
> ACK.
>=20
> The attached patch removes the sysfs interface from iwl3945 and uses
> the rfkill subsystem instead.

> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -5913,7 +5913,9 @@ static void __iwl3945_down(struct iwl3945_priv
> *priv)
>  			       test_bit(STATUS_GEO_CONFIGURED,
> &priv->status) <<
>  					STATUS_GEO_CONFIGURED |
>  			       test_bit(STATUS_IN_SUSPEND,

That patch is badly mangled by line-wrapping.

johannes

--=-9RmZwegzYkOievkj6PkK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWN53AAoJEKVg1VMiehFYMiwP/j51xcSjXqjRKsUwuA5fofSz
ZkR7n+AlxHI/KqrYDOYJSrCjMOCanfDDAyDaJ0ILYls+GmYwLUv93pdqgMjqygBS
w5P49AbtvMDQql+oOfhQnzmpZjMlFULqTFXAlUKuBKRas+KV/bignHS+ExQ/aSSh
rglmE7oi5DFbkz9Dv71kwer0hDVRwcydXu73fpjZQ0uoCF4iqEAdVhojcWmHFuJi
WIDTm3nOjEN0Oot7qbhRqZAW86SZ6kMTEDyRZa2D0PYjY7m2UuFIGaMbx1rUw47X
a5KbkYdtuO7DdB8KuSbnIeGgQ07iTZm+Wtrh/gOZPeS/2JkR19zNsvkRVmUaiOFx
YhNZ47KE3r7ypy1x5wH6M+cKW7sLIUBcgnQtGaEFDyRdTJnSO1yJEOxx2UeSiVpZ
kI23zAgP6EpT3zIBqUqkibI9EQB7G/Pk66v+ADr/2gXaZr8C4wSXBrnBNQ/PtyGE
MHAGlQDWjg7PvTYz2XEfXie2ku3XmdFMyK0f8tzPWT2I00hK0MPitWj+Z/Np52OB
CzAFFt268JiZtJ9olTg/iBrPpR9jFchSyKzHHYxe38ZXqQ/WllNrapI9+JP380o0
yL0Ocv6o4XIQpYNxu0LnCLYSPKhIFHq5D2MMEyf9lZkdv+Xz44S2nl55n5K7Wpkf
U4MjIRehoDAegXXEvWow
=6NWI
-----END PGP SIGNATURE-----

--=-9RmZwegzYkOievkj6PkK--

