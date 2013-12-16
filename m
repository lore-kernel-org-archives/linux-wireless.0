Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39677 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3LPR0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 12:26:46 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so2441146eaj.9
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 09:26:45 -0800 (PST)
Message-ID: <52AF37CE.4020906@gmail.com> (sfid-20131216_182649_958117_302C1BB5)
Date: Mon, 16 Dec 2013 19:26:38 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matt Chen <machen@suse.com>,
	John Linville <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: firmware for Intel Wireless adapter - 7260 / 3160
References: <CANUX_P3PxN3ENgizJ-V5D0Of45AFoGcJ2wuzW-8ZwzToxTkcdQ@mail.gmail.com>
In-Reply-To: <CANUX_P3PxN3ENgizJ-V5D0Of45AFoGcJ2wuzW-8ZwzToxTkcdQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Emeb98DBDJRDxD4W0i1jiOU5UsVUomWke"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Emeb98DBDJRDxD4W0i1jiOU5UsVUomWke
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ben,

I have a new firmware for 7260 / 3160 - new version is 22.1.7.0.

Please pull - thanks!


The following changes since commit 7d0c7a8cfd78388d90cc784a185b19dcbdbce8=
24:

  Merge branch 'wilink4' of
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/linux-firmware
(2013-10-13 21:11:46 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware
master

for you to fetch changes up to 478227556dfc3563892c3e1ec3abfa03c663e10d:

  iwlwifi: update firmware for 7260 / 3160 devices (2013-12-15 21:40:38
+0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update firmware for 7260 / 3160 devices

 iwlwifi-3160-7.ucode |  Bin 670172 -> 670484 bytes
 iwlwifi-7260-7.ucode |  Bin 682892 -> 683236 bytes
 2 files changed, 0 insertions(+), 0 deletions(-)


--Emeb98DBDJRDxD4W0i1jiOU5UsVUomWke
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSrzfRAAoJEC0Llv5uNjIBivYP/0u29ExBWRF4mfT6Gec1Nqj3
XqPXzmHh2J9hMTJLTIsJYvij8EroTP1zWsOH6dRSVeP4bxfNj2aiVHdOzo79GBpE
Ho3qFZ+lXvkPQ17f+TZCM8tHlOwLs5h1hcxvzEu6f30Zquaw6N7hLiyeu/6CFtJs
ylLDk2M6nZTAigjCVV291uLrbC6tixCOC383jr9K6Kwu67jGrcHWTtel3Wc51JSi
5J7VWz2jvj0y+8kDlHB/iUVMazAKry+6c9VPMxg1z02XOOeDypxSxs4d+37Rdtf0
7tamLPSTqTMQu4a9DtNau3/CHF6OeBDHfspKNI47uSmpLiMvOzpIe65Xa8UVgvCM
xPxWeqCu+5Qp4I0VRC1JyVR3zhH0PrWoDhlopxQp5k9B4Fp+jMXxbqcIIdJlKDtJ
QnvAZEH30/kLEkKKHMR7+tc5yBVfeMtPorh1GNBVjxXKdw7H97vYNHGTS6OL+7XO
OxUxDpswzoX9RJFKLdA1VMFFWZxlmTHN83KwcRlI8poYJxm7gq4hTiVBl7G+FdHl
fOE/NyZUqtc7kirEBpo/Gxq39rw2+V4simIq0OzTAQJuuQQGiWLt1wJSw79CmmPk
IcubVPG24mGffXoJ78LIELCfjBvgQfhZYQtnzCrd5c2e/rffdeWax/33M0+YilEw
HZvJR8nRWzQAPUY6Ykr3
=aeHn
-----END PGP SIGNATURE-----

--Emeb98DBDJRDxD4W0i1jiOU5UsVUomWke--
