Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bronze.linx.net ([195.66.232.51]:41799 "EHLO bronze.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbYFDTZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 15:25:29 -0400
Subject: [mac80211] Implement EU regulatory domain
From: Tony Vroon <tony@linx.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RMm01laCEYObkS0MIQdl"
Date: Wed, 04 Jun 2008 19:51:19 +0100
Message-Id: <1212605479.4235.1.camel@localhost> (sfid-20080604_212532_313197_6A74B24F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RMm01laCEYObkS0MIQdl
Content-Type: multipart/mixed; boundary="=-TUAOY7Nd4+mjyjhflTBD"


--=-TUAOY7Nd4+mjyjhflTBD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Please consider the attached patch (inline sign-off & short description)
for inclusion in 2.6.27

Regards,
Tony V.
UNIX systems administrator
London Internet Exchange (LINX)

--=-TUAOY7Nd4+mjyjhflTBD
Content-Disposition: attachment; filename=mac80211-eu-regdom.patch
Content-Type: text/x-patch; name=mac80211-eu-regdom.patch; charset=UTF-8
Content-Transfer-Encoding: base64

SW1wbGVtZW50IG1pc3NpbmcgRVUgcmVndWxhdG9yeSBkb21haW4gZm9yIG1hYzgwMjExLiBCYXNl
ZCBvbiB0aGUgDQppbmZvcm1hdGlvbiBpbiBJRUVFIDgwMi4xMS0yMDA3IChzcGVjaWZpY2FsbHkg
cGFnZXMgMTE0MiwgMTE0MyAmIDExNDgpIA0KYW5kIEVUU0kgMzAxIDg5MyAoVjEuNC4xKS4NCldp
dGggdGhhbmtzIHRvIEpvaGFubmVzIEJlcmcuDQoNClNpZ25lZC1vZmYtYnk6IFRvbnkgVnJvb24g
PHRvbnlAbGlueC5uZXQ+DQoNCi0tLSBuZXQvd2lyZWxlc3MvcmVnLmMub3JpZwkyMDA4LTA2LTA0
IDE2OjI5OjU0LjAwMDAwMDAwMCArMDEwMA0KKysrIG5ldC93aXJlbGVzcy9yZWcuYwkyMDA4LTA2
LTA0IDE5OjI1OjM0LjAwMDAwMDAwMCArMDEwMA0KQEAgLTgwLDYgKzgwLDIzIEBADQogCQkJCSAg
ICAgSUVFRTgwMjExX0NIQU5fUkFEQVIpLA0KIH07DQogDQorc3RhdGljIGNvbnN0IHN0cnVjdCBp
ZWVlODAyMTFfY2hhbm5lbF9yYW5nZSBpZWVlODAyMTFfRVVfY2hhbm5lbHNbXSA9IHsNCisJLyog
SUVFRSA4MDIuMTFiL2csIGNoYW5uZWxzIDEuLjEzICovDQorCVJBTkdFX1BXUigyNDEyLCAyNDcy
LCAyMCwgNiwgMCksDQorCS8qIElFRUUgODAyLjExYSwgY2hhbm5lbCAzNiovDQorCVJBTkdFX1BX
Uig1MTgwLCA1MTgwLCAyMywgNiwgSUVFRTgwMjExX0NIQU5fUEFTU0lWRV9TQ0FOKSwNCisJLyog
SUVFRSA4MDIuMTFhLCBjaGFubmVsIDQwKi8NCisJUkFOR0VfUFdSKDUyMDAsIDUyMDAsIDIzLCA2
LCBJRUVFODAyMTFfQ0hBTl9QQVNTSVZFX1NDQU4pLA0KKwkvKiBJRUVFIDgwMi4xMWEsIGNoYW5u
ZWwgNDQqLw0KKwlSQU5HRV9QV1IoNTIyMCwgNTIyMCwgMjMsIDYsIElFRUU4MDIxMV9DSEFOX1BB
U1NJVkVfU0NBTiksDQorCS8qIElFRUUgODAyLjExYSwgY2hhbm5lbHMgNDguLjY0ICovDQorCVJB
TkdFX1BXUig1MjQwLCA1MzIwLCAyMywgNiwgSUVFRTgwMjExX0NIQU5fTk9fSUJTUyB8DQorCQkJ
CSAgICAgSUVFRTgwMjExX0NIQU5fUkFEQVIpLA0KKwkvKiBJRUVFIDgwMi4xMWEsIGNoYW5uZWxz
IDEwMC4uMTQwICovDQorCVJBTkdFX1BXUig1NTAwLCA1NzAwLCAzMCwgNiwgSUVFRTgwMjExX0NI
QU5fTk9fSUJTUyB8DQorCQkJCSAgICAgSUVFRTgwMjExX0NIQU5fUkFEQVIpLA0KK307DQorDQog
I2RlZmluZSBSRUdET00oX2NvZGUpCQkJCQkJCVwNCiAJewkJCQkJCQkJXA0KIAkJLmNvZGUgPSBf
X3N0cmluZ2lmeShfY29kZSksCQkJCVwNCkBAIC05MCw2ICsxMDcsNyBAQA0KIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgaWVlZTgwMjExX3JlZ2RvbWFpbiBpZWVlODAyMTFfcmVnZG9tc1tdID0gew0KIAlS
RUdET00oVVMpLA0KIAlSRUdET00oSlApLA0KKwlSRUdET00oRVUpLA0KIH07DQogDQogDQo=


--=-TUAOY7Nd4+mjyjhflTBD--

--=-RMm01laCEYObkS0MIQdl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhG5CcACgkQp5vW4rUFj5olkwCfc+adwwg7YKR9zmcFFJPLt8d4
EOAAni+P68jm/H2dytK7KfsmORfw+0w2
=fuEQ
-----END PGP SIGNATURE-----

--=-RMm01laCEYObkS0MIQdl--

