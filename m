Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbZJ1Oyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 10:54:37 -0400
Subject: Re: iwlist wlan0 scan disrupts communications
From: Johannes Berg <johannes@sipsolutions.net>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <86201b3f0910280747q557a6153oec929e8235459c8f@mail.gmail.com>
References: <86201b3f0910271340t51aa6c0bgff43e6e7211a0dee@mail.gmail.com>
	 <1256676190.4237.27.camel@johannes.local>
	 <86201b3f0910280747q557a6153oec929e8235459c8f@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WS34He4sDkt6xDrlOp5B"
Date: Wed, 28 Oct 2009 15:54:11 +0100
Message-ID: <1256741651.4237.112.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WS34He4sDkt6xDrlOp5B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-28 at 10:47 -0400, Charles Gordon wrote:

> Thanks for the information.  After doing some more testing I found
> that the association to the AP is sometimes lost and that mac80211
> does not recover automatically.  You have to type the command "wpa_cli
> reassociate" to trigger the stack to reassociate with the AP.  Is this
> one of the things that is, or will be, fixed in later releases?

I don't know. Normally, wpa_supplicant should notice this and re-connect
by itself.

johannes

--=-WS34He4sDkt6xDrlOp5B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK6FsPAAoJEODzc/N7+QmacpEP/RRgV5vY6Fujmohmo2CYsWHu
GqmsfNYKBw9KNjsv0NCeWB1Tc0ZnxzjRFLe6Hx69QVUtoy5/Bage6aYV4U6uydM6
uaTVkzk2fOTAcXmgpG80HKs5VnZkA8LMcRbrvsepJ1G+7CBA+ox4jdKfZkMWws9L
w/YCvMsf93gL/zcm7F13VTyeORRoZKzPkWkOJcapZLq/drGXMFXOsJ/9RyeVO+rt
k7TrQx055QTibveMw0fv+BkhFVV3gZFGZgZ9S4buQD9hKhPOXxUPXDzhn3B+zLAl
ejh4ceMh9m4pDc8JmR7jnSBtLnffvKZP37CMVMhlvWP5x/nDJsOijH4gIikOPX4z
Rlznp+tAc3ceyiICSMkbLGSvkb9RAkZaRUk5ZUZ1+FtwaHApE1f0Jr0JYtk3yTYT
aPMAzz5DH/Z5V2O1t935rLBFg1NmGse98Yz5HL5sbo2o5R4+vBvGb+z326RhftBS
H/dyrxon3TNLJn5p+jviO4Lb9QuNFkCvjOQJyQ5PWhseHMgjHi2O7lYGsVa0XEUu
nBsg1o42rYOS4deTfuca8TiVoOtKecCZ4AMBNCNcw9FgefE9QplaowYu/NTxVnmL
5xgy/lzVwjILzgQ4gRlgmLvU4zrgkwpnVlc7yEtj4NFvzBuysz599Flc/1Sprnk5
swIInfKg7EHgKqOGFqht
=FDC7
-----END PGP SIGNATURE-----

--=-WS34He4sDkt6xDrlOp5B--

