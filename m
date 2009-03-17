Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41889 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbZCQWeB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 18:34:01 -0400
Message-ID: <49C02543.4040204@hauke-m.de> (sfid-20090317_233405_263481_F52166FE)
Date: Tue, 17 Mar 2009 23:33:39 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [compat] Add MWL8K support
References: <49C020F9.9080301@hauke-m.de>
In-Reply-To: <49C020F9.9080301@hauke-m.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig08FC066EEE3039CDEDC4585D"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig08FC066EEE3039CDEDC4585D
Content-Type: multipart/mixed;
 boundary="------------030708010802050604030904"

This is a multi-part message in MIME format.
--------------030708010802050604030904
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Add support for Marvell 88W8xxx PCI/PCIe Wireless to compat-wireless.
Without this patch it has to be deactivated in
drivers/net/wireless/Makefile.

--
Hauke Mehrtens
Hauke Mehrtens wrote:
> The first patch makes compat-wireless work with wireless-testing
> master-2009-03-17 again. Patch number 2 and 3 are removing some diffs
> and patch 4 makes the activation on debug options easier and adds some
> missing ones.
>=20
>=20

--------------030708010802050604030904
Content-Type: text/x-diff;
 name="0005-Add-Marvell-88W8xxx-PCI-PCIe-Wireless-support-to-com.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename*0="0005-Add-Marvell-88W8xxx-PCI-PCIe-Wireless-support-to-com.pa";
 filename*1="tch"

=46rom 5f652e500e991883b4a76923228d093d3b295d49 Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Tue, 17 Mar 2009 23:29:43 +0100
Subject: [PATCH] Add Marvell 88W8xxx PCI/PCIe Wireless support to compat-=
wireless

---
 config.mk               |    2 ++
 scripts/admin-update.sh |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index b0f6e44..84bf609 100644
--- a/config.mk
+++ b/config.mk
@@ -229,6 +229,8 @@ endif
 CONFIG_ATMEL=3Dm
 CONFIG_PCI_ATMEL=3Dm
=20
+CONFIG_MWL8K=3Dm
+
 endif
 ## end of PCI
=20
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index b40a5d6..0226053 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -65,6 +65,7 @@ DRIVER_FILES=3D"adm8211.c  adm8211.h"
 DRIVER_FILES=3D"$DRIVER_FILES rndis_wlan.c"
 DRIVER_FILES=3D"$DRIVER_FILES mac80211_hwsim.c"
 DRIVER_FILES=3D"$DRIVER_FILES at76c50x-usb.c at76c50x-usb.h"
+DRIVER_FILES=3D"$DRIVER_FILES mwl8k.c"
=20
 mkdir -p include/linux/ include/net/ include/linux/usb \
 	include/linux/unaligned \
--=20
1.5.6.3


--------------030708010802050604030904--

--------------enig08FC066EEE3039CDEDC4585D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJwCVIAAoJEIZ0px9YPRMycxMP/3+7TeSCBuIR03BQTDEZIbTr
VWyQbRK7FB+6R+k3AgYre1pSFHSbquiPQTNzbOBqWj9LdmOBtqfO4djw0zxKjdpo
Q4wFGm9I6bmJRdvb0hhEHRMtw1Y8fLpxVfTXc2ewi/0UWj0PZxQTVnfr75fCfyGI
awFD0jrzWpj/8ITm4BlToFk/n3Hyhg8ZUhObjdMGmQ0CdpBszD1pfY7vQAU4PmEr
xycjqD4IMM1r5fooYzdl64FS1fEeBhuQ6AopcT8CuHPDiI4uOjYLP7lRN1lbgGf4
63NKWWK/fyBBQyW1S1AFL1+fdBM+iEhBQ51HwvlxmLKOEK5sRYLuftBM4Jb0d25Z
fwYWwBSEv8i5/po9JwCSNCbr//kTmdLwd6IVG/3G7ZiSDDiEcbkBBf/CxGR+AG1h
gAUN/MORFQ8zLYlRVtt7aUa7WghSvnJOFoLSHqL1HcWGRM7hbDLlvlCJ/WyaZ1SI
JUsnZ4p7joz/+BrRkPzsQFfegL4XiXOfssT4/5VGiYk+j8ktOLPgsw88rcHd8VZi
UyvNHZ8zvA4rl+KDkg0R4HYRYAqoJfPkZjlNnaQczKUyscDkuI4ACBwzoLfyKHEw
NSygjawy+/HGmirV8ToIpnbxoOZOj82BJm7lSLufMMsFxh1ctDimpmNy2yKB8YtL
ReOpZUbLQyYrqwBTrPZg
=c90r
-----END PGP SIGNATURE-----

--------------enig08FC066EEE3039CDEDC4585D--
