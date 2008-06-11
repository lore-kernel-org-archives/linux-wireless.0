Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36782 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYFKVM2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:12:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by hauke-m.de (Postfix) with ESMTP id AD45F71808C
	for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 23:12:23 +0200 (CEST)
Received: from hauke-m.de ([127.0.0.1])
	by localhost (hauke-m.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FLHDaqLIP-nQ for <linux-wireless@vger.kernel.org>;
	Wed, 11 Jun 2008 23:12:16 +0200 (CEST)
Received: from [192.168.0.10] (host-091-096-208-016.ewe-ip-backbone.de [91.96.208.16])
	by hauke-m.de (Postfix) with ESMTP id CA61C718083
	for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 23:12:15 +0200 (CEST)
Message-ID: <48503FAF.8000108@hauke-m.de> (sfid-20080611_231232_399201_2B6C8B81)
Date: Wed, 11 Jun 2008 23:12:15 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Open source driver with binary HAL for BCM4313 from Broadcom
References: <48500F14.8070300@canonical.com>
In-Reply-To: <48500F14.8070300@canonical.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig57F575483C6D33EF537835FD"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig57F575483C6D33EF537835FD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Some time ago I found some source code for the wireless device in my
Broadcom brcm63xx router in the source code package for it.
It contains ~3 MB of source code for the wireless device (Broadcom
BCM43XX 802.11abg), but there are no make files and the build process
takes an pre-compiled version. It looks like someone forgot to delete
some files.

There is a text like this in all files:
This is UNPUBLISHED PROPRIETARY SOURCE CODE of Broadcom Corporation;

The package can be downloaded at:
http://broadband.eip.siemens.ch/public/GPL_source/GPL_source_CL_SL_SLI_se=
ries_consumer_release.tar

The code is in the directory broadcom/net/wl/impl1

If you know Broadcom had published it, forget about this e-mail.

--
Hauke

Tim Gardner schrieb:
> John,
>=20
> Here is the URL to Broadcom's web site advertising their open source
> driver with support for the BCM4313.
>=20
> http://www.broadcom.com/support/802.11/linux_sta.php
>=20
> rtg


--------------enig57F575483C6D33EF537835FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBSFA/toZ0px9YPRMyAQI4jg//dMQ9DQfNqULKubQWlaPIOUyJ0SRm+Rku
UGGi6rAc9xOLKJubvPO3n4Go1A1u0Muuy1fyVNSW8tIqOiCFtszNw8hcKkKpNFsW
tZCPErKTj/NeZQFinwIM1PGgC1qEr1BmZPD6ZA0+w6uDH1ypoJ5C8sSYEq6TN8WL
+z+ZJ2lNSNWbHi5Dq6gzHtm/eFCo/yf6X97s69yZkyobrkkfWT0SdHsaj+5i6gyz
6t0IOTlK1J8++CRt/oBaQBaOu18xwHCecxd7Uly+aEasAte6Fo//Vsrx+m2Jgxcb
xBx0H3ewL6hDTeuEWTWUE3ENH1wmLtjILLazDehI3SYyFUX/KwRFRWfofhnpDmyl
bUcpFLPvpsFfddHDpzyuCwby2BQ96aYuptnkGFFON155kczuq+ZoJCIbsOBHBmfH
eoAceH8VNSydnV9OzM97h27SEHf6E0ub6k694pN/Muyh4BZ6yvWZmshuPCz/S5Oz
O4p+dGjaZV5+jOPqUjMf7wU3G356WAqT05EOYKrfaw8Nr2SgVrFoW5unRtDYFqwd
1EKoiZHrfo50s+4SXgG98nCR+QT/88HFR4NBWpecIYFxP64s5PW57v1CNL/OhyMH
wpl40rNSbgy/FqoPE2/0l9UGTOZ4nx4rdmzquMox4tFNiRZxsxC4p6InE4FHObyK
3lFT+73H0nE=
=itck
-----END PGP SIGNATURE-----

--------------enig57F575483C6D33EF537835FD--
