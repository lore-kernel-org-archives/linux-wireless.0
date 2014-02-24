Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:43404 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaBXHuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 02:50:37 -0500
Received: by mail-wg0-f54.google.com with SMTP id l18so4283220wgh.33
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 23:50:36 -0800 (PST)
Message-ID: <530AF9AE.4000000@gmail.com> (sfid-20140224_085041_680460_82971EBD)
Date: Mon, 24 Feb 2014 09:50:06 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: firmware for Intel Wireless adapter 7260 / 3160 - 22.24.8.0
References: <530AF48F.8050802@gmail.com>
In-Reply-To: <530AF48F.8050802@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3fLCPpkeeskfPI3nD1p6irm5Ep8xp6VQK"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3fLCPpkeeskfPI3nD1p6irm5Ep8xp6VQK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ben,

I have a new firmware for 7260 / 3160 - new version is 22.24.8.0.

Please pull - thanks!

The following changes since commit d7f8a7c81a3aaf06e4166ff17f9ef7cae83191=
6f:

  Remove executable permissions from firmware files (2014-01-27 00:49:23 =
+0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware =
master

for you to fetch changes up to 509a474f31360bce4546046ab037ddad1cc0471a:

  iwlwifi: update firmware for 7260 / 3160 devices (2014-02-24 09:19:42 +=
0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update firmware for 7260 / 3160 devices

 WHENCE               |    6 +++---
 iwlwifi-3160-8.ucode |  Bin 662032 -> 667284 bytes
 iwlwifi-7260-8.ucode |  Bin 674628 -> 679780 bytes
 3 files changed, 3 insertions(+), 3 deletions(-)



--3fLCPpkeeskfPI3nD1p6irm5Ep8xp6VQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTCvm1AAoJEC0Llv5uNjIBSvMP/jpqxe2n5fzxz5bDOhT+4TOo
uVbk2iKUnOJzZ/xnwqD8C2FIN5XMJdD5Vxyebtr3fQ5pB0JMFDhH9zm1mEMVFPQI
Hu++hemOoF/bVqnwvVdswyUcfZHoKaqhHJz2vW0/8nc/pMf8cpPXtqPdqb/NlQfd
R0fZMmG7GxxWNhB96aB1r+jEi+7NZZk4BOdPo6uuVcC4Y8C+E3TFIaugJ5i8TMxl
ul8RVF4Od3yyEHt/j9sTEPEeG9B84lb2gs5CnDZkMe4NQ6ZqCQqombuEyT5byU3T
4sLDFS8iiWPmBR0SgnJW8GurTbv26xN0gHKqeaP4Cdeh+QdxAT6ku5Xn5uPwZ5rm
BOXeAshfBltz3qHfPGBvJfu97OFJwvgYW8gPO/E1aS6i5YTKzDVFyIF5ftfidIWK
M4sszE+nPuPaOl8xCtKG51tzpvdjB8QV8uuLpxBMrBjihK7OoQZSIpqsP9zvnVZR
WJspi8g9qUqphVxP1AF01zqXrTqbBx7Y8j+uAjqcBC/b0YJ+Ei/GO3yI7y01+nMa
6/fcEbZaBkEZhGNxdOD1ngpnG4yv7l5VImSZf9fFZYzhlgMw+i0AzkaCgA+LV07z
p6iyt/srqsDYuADs9XpAHxZanbBFQiGinmwMfnb/tE5//yJf/ckYzYAmg6sEz284
x7FWTQR4J8E/NH/ES0XS
=Spzu
-----END PGP SIGNATURE-----

--3fLCPpkeeskfPI3nD1p6irm5Ep8xp6VQK--
