Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47445 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792AbYBVVmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 16:42:11 -0500
Subject: Re: [PATCH 0/8] mac80211 sta info and related changes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <20080222111644.183587000@sipsolutions.net> (sfid-20080222_140858_866959_D0B6572D)
References: <20080222111644.183587000@sipsolutions.net>
	 (sfid-20080222_140858_866959_D0B6572D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9gaCIMipFsPiCMkv3qiu"
Date: Fri, 22 Feb 2008 22:41:59 +0100
Message-Id: <1203716519.3790.0.camel@johannes.berg> (sfid-20080222_214222_245561_66963837)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9gaCIMipFsPiCMkv3qiu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  * split ieee80211_key_alloc
>    Preparation for RCU-ifying STA info, split key allocation into
>    allocation and insertion
>=20
>  * RCU-ify STA info structure access
>    Remove STA refcount and instead protect them by RCU

This made key.c spew warnings, sorry, I'm fixing it now. I'll also
rebase this on top of the 11s patches.

johannes

--=-9gaCIMipFsPiCMkv3qiu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR79BpqVg1VMiehFYAQIksA/+Oi7Zyvz4UCheOWN35s+JDCENV9bHdmFy
0qgge9AkZaZy9zr/CSPSGEgaDL6FUbMtQRNEaWlI/w9WMZP+ZTFctO36QLSPJqYE
KEAkI6aJkc1FdVSTv7wnMIrnhtgrm5HMgsxvj98Z/3UXRCfKh/h0RzCa2n1C4aM2
wPf8nyI0k+HMobGMtaS08Dhrc1Fotctg2UCUZxZ5sCvli1cS2zZmZ9AKkun4Xn/4
VzTM6a/wtdL5Z2KdbuSB3rL2rK275H/NdeVOrp9YAAbBuAz6PkY0m+KJSBPcBhBY
u6buZMuELI2Wn3ZbMJuRA2wDPzbhdmosOiAfLFam9MqBRKvp2uwYLTnfn45nCajM
VHIv31//0dWK79Ej3OhvLXNJHJGqKnuWd1/1PD97sUkAR+Ce88jjrMvJH8GtzUlK
ADTqpfUywAnnqdGFxi1pDiNDPpGenJCCwS/0d7Q34dMOlHwySPIcsVSyCJUMS7KT
GfZqvljzwoGyQlKYgCR9lwDT6UDB5Bg2+Zee6rYwX/qQR1/nurWVbHkA0sHUMkgK
sJTG5g9QsWO/WYP3qBiQaj1JZD8o2GWAMwzSL/MUmxr5UR0YeVIjFtqjhNAOSCDv
LEq2BXCWtFvrp2rDXh3WiAXfSfGwnAjQRXE/AMyhCpbE1cZ34EOQ8rWRP687y0Yp
OZuaMSzGRQc=
=9N62
-----END PGP SIGNATURE-----

--=-9gaCIMipFsPiCMkv3qiu--

