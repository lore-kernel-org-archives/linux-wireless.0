Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYJ1Sgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:36:31 -0400
Subject: sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>, Dan Williams <dcbw@redhat.com>,
	Daniel Drake <dsd@gentoo.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-buDxcgSuZp+BwGSdfJ1B"
Date: Tue, 28 Oct 2008 16:57:17 +0100
Message-Id: <1225209437.3598.16.camel@johannes.berg> (sfid-20081028_193636_333303_B358B632)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-buDxcgSuZp+BwGSdfJ1B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

These look like bugs:

drivers/net/wireless/iwlwifi/iwl3945-base.c:4848:18: warning: invalid assig=
nment: |=3D
drivers/net/wireless/iwlwifi/iwl3945-base.c:4848:18:    left side has type =
unsigned char
drivers/net/wireless/iwlwifi/iwl3945-base.c:4848:18:    right side has type=
 restricted __le32

drivers/net/wireless/libertas/cmd.c:609:16: warning: cast to restricted __l=
e16
drivers/net/wireless/libertas/cmd.c:611:16: warning: cast to restricted __l=
e16


These seem harmless:

drivers/net/wireless/zd1211rw/zd_usb.c:359:17: warning: implicit cast from =
nocast type

drivers/net/wireless/ath9k/main.c:1836:28: warning: incorrect type in argum=
ent 2 (different base types)
drivers/net/wireless/ath9k/main.c:1836:28:    expected restricted pci_power=
_t [usertype] state
drivers/net/wireless/ath9k/main.c:1836:28:    got int
drivers/net/wireless/ath9k/hw.c: In function =E2=80=98ath9k_hw_eeprom_set_b=
oard_values=E2=80=99:
drivers/net/wireless/ath9k/hw.c:544: warning: =E2=80=98ant_config=E2=80=99 =
may be used uninitialized in this function
drivers/net/wireless/ath9k/hw.c:4818:17: warning: symbol 'tmp' shadows an e=
arlier one
drivers/net/wireless/ath9k/hw.c:4681:6: originally declared here
drivers/net/wireless/ath9k/hw.c:5020:17: warning: symbol 'tmp' shadows an e=
arlier one
drivers/net/wireless/ath9k/hw.c:4930:6: originally declared here

[and a whole bunch in b43]

johannes

--=-buDxcgSuZp+BwGSdfJ1B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBzZZAAoJEKVg1VMiehFYED4P/iwwOXOOern+0I2jiwdWo/63
2T8ErZFEMmL+cL6aktUKzCor3NGZSFzYeID5NHXyHDSWvrySL91LdJIXgKYyEYfq
nj0zefBcuOvI1rMdyLlUyA6p8UjkI+c+qQQMapAHmxN2ALxqKKObYD58pfCAc1G5
phIeHLh2xpfizeHQroCo8GUXrJ5UUuF8TzjoK91S3T2FR0EcdunAvlH4waw06mbl
plz4V3dZyRt8O8lZMiEYEhPqzJrce3+fU9vGzWTst+5+ZFVliKVavWdKG31Jfw5Q
Mc37Xpr22n4UbzIIhFK8Gb5tBJmr7vLwBjEnI1fLGV2smeRcik1QBXgOxm98rKUC
HJGuUySI2D+JFAtjl1XZHVAyCeb+uuim7KPTSQt33R3G6JDx4Ec7duCoxyfMxFmP
juDyB2Z2pBSXTVIKuRrpDYXxKhQZr0s3DHlPpnqjdeQS64OUBpEdBLfutCWINvKm
/lnxTIWAId4rZ3pxAzMyz2DW8dNvz21qi7dPPZLptv6hhxccu1IAtj+iv0vmca4G
c+iYJLq9LoTaneMU/u51c280M5AzUwy3+0/Kc+GZJOBdTX6mxLSd/PTZ+xQmxerI
f0onjzuJmMmufMRAVEqfnaACgiDu1TVyFw41pY253itKdET7km6PuFCRbJsCXJJ5
x0kSXcoZlSvhsfuPKD3i
=2SKh
-----END PGP SIGNATURE-----

--=-buDxcgSuZp+BwGSdfJ1B--

