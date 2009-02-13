Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:36696 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZBMK4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 05:56:10 -0500
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
  ranges
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890902111346p4a689c9bvdb891eab388c5154@mail.gmail.com>
References: <1234202993.21570.18.camel@localhost>
	 <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com>
	 <1234203811.21570.19.camel@localhost> <20090209183924.GA6069@tuxdriver.com>
	 <1234207263.6694.1.camel@localhost> <1234208152.6694.4.camel@localhost>
	 <20090210013941.GA4386@tesla> <1234230689.3793.15.camel@localhost>
	 <20090210020708.GC4386@tesla> <1234379981.4789.7.camel@localhost>
	 <43e72e890902111346p4a689c9bvdb891eab388c5154@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-l0UJDzWOcUf4XTnZ2Kjc"
Date: Fri, 13 Feb 2009 10:55:26 +0000
Message-Id: <1234522526.4331.1.camel@localhost> (sfid-20090213_115614_404750_099DE9DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l0UJDzWOcUf4XTnZ2Kjc
Content-Type: multipart/mixed; boundary="=-Zp3oiNN2HvEybEcSepPb"


--=-Zp3oiNN2HvEybEcSepPb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-11 at 13:46 -0800, Luis R. Rodriguez wrote:
> Looks good here -- can you please provide 'iw list' output prior to
> trying to associate.

As expected, the "world domain". Details attached.
Leaving the 802.11A spectrum alone won't help if your defaults don't
enable it.

>  Luis

Regards,
Tony V.

--=-Zp3oiNN2HvEybEcSepPb
Content-Disposition: attachment; filename="iwlist.earlyboot.txt"
Content-Type: text/plain; name="iwlist.earlyboot.txt"; charset="UTF-8"
Content-Transfer-Encoding: base64

V2lwaHkgcGh5MA0KCUJhbmQgMToNCgkJSFQgY2FwYWJpbGl0aWVzOiAweDA4N2UNCgkJCSAqIDIw
LzQwIE1IeiBvcGVyYXRpb24NCgkJCSAqIFNNIFBTIGRpc2FibGVkDQoJCQkgKiBIVC1ncmVlbmZp
ZWxkDQoJCQkgKiAyMCBNSHogc2hvcnQgR0kNCgkJCSAqIDQwIE1IeiBzaG9ydCBHSQ0KCQkJICog
bWF4IEEtTVNEVSBsZW4gNzkzNQ0KCQlIVCBBLU1QRFUgZmFjdG9yOiAweDAwMDMgKDY1NTM1IGJ5
dGVzKQ0KCQlIVCBBLU1QRFUgZGVuc2l0eTogMHgwMDA1ICg0IHVzZWMpDQoJCUhUIE1DUyBzZXQ6
IGZmIGZmIGZmIDAwIDAxIDAwIDAwIDAwIDAwIDAwIGMyIDAxIDAxIDAwIDAwIDAwDQoJCUZyZXF1
ZW5jaWVzOg0KCQkJKiAyNDEyIE1IeiBbMV0gKDE1LjAgZEJtKSAocGFzc2l2ZSBzY2FubmluZywg
bm8gSUJTUykNCgkJCSogMjQxNyBNSHogWzJdICgxNS4wIGRCbSkgKHBhc3NpdmUgc2Nhbm5pbmcs
IG5vIElCU1MpDQoJCQkqIDI0MjIgTUh6IFszXSAoMTUuMCBkQm0pIChwYXNzaXZlIHNjYW5uaW5n
LCBubyBJQlNTKQ0KCQkJKiAyNDI3IE1IeiBbNF0gKDE1LjAgZEJtKSAocGFzc2l2ZSBzY2Fubmlu
Zywgbm8gSUJTUykNCgkJCSogMjQzMiBNSHogWzVdICgxNS4wIGRCbSkgKHBhc3NpdmUgc2Nhbm5p
bmcsIG5vIElCU1MpDQoJCQkqIDI0MzcgTUh6IFs2XSAoMTUuMCBkQm0pIChwYXNzaXZlIHNjYW5u
aW5nLCBubyBJQlNTKQ0KCQkJKiAyNDQyIE1IeiBbN10gKDE1LjAgZEJtKSAocGFzc2l2ZSBzY2Fu
bmluZywgbm8gSUJTUykNCgkJCSogMjQ0NyBNSHogWzhdICgxNS4wIGRCbSkgKHBhc3NpdmUgc2Nh
bm5pbmcsIG5vIElCU1MpDQoJCQkqIDI0NTIgTUh6IFs5XSAoMTUuMCBkQm0pIChwYXNzaXZlIHNj
YW5uaW5nLCBubyBJQlNTKQ0KCQkJKiAyNDU3IE1IeiBbMTBdICgxNS4wIGRCbSkgKHBhc3NpdmUg
c2Nhbm5pbmcsIG5vIElCU1MpDQoJCQkqIDI0NjIgTUh6IFsxMV0gKDE1LjAgZEJtKSAocGFzc2l2
ZSBzY2FubmluZywgbm8gSUJTUykNCgkJCSogMjQ2NyBNSHogWzEyXSAoZGlzYWJsZWQpDQoJCQkq
IDI0NzIgTUh6IFsxM10gKGRpc2FibGVkKQ0KCQlCaXRyYXRlczoNCgkJCSogMS4wIE1icHMNCgkJ
CSogMi4wIE1icHMgKHNob3J0IHByZWFtYmxlIHN1cHBvcnRlZCkNCgkJCSogNS41IE1icHMgKHNo
b3J0IHByZWFtYmxlIHN1cHBvcnRlZCkNCgkJCSogMTEuMCBNYnBzIChzaG9ydCBwcmVhbWJsZSBz
dXBwb3J0ZWQpDQoJCQkqIDYuMCBNYnBzDQoJCQkqIDkuMCBNYnBzDQoJCQkqIDEyLjAgTWJwcw0K
CQkJKiAxOC4wIE1icHMNCgkJCSogMjQuMCBNYnBzDQoJCQkqIDM2LjAgTWJwcw0KCQkJKiA0OC4w
IE1icHMNCgkJCSogNTQuMCBNYnBzDQoJCQkqIDYwLjAgTWJwcw0KCUJhbmQgMjoNCgkJSFQgY2Fw
YWJpbGl0aWVzOiAweDA4N2UNCgkJCSAqIDIwLzQwIE1IeiBvcGVyYXRpb24NCgkJCSAqIFNNIFBT
IGRpc2FibGVkDQoJCQkgKiBIVC1ncmVlbmZpZWxkDQoJCQkgKiAyMCBNSHogc2hvcnQgR0kNCgkJ
CSAqIDQwIE1IeiBzaG9ydCBHSQ0KCQkJICogbWF4IEEtTVNEVSBsZW4gNzkzNQ0KCQlIVCBBLU1Q
RFUgZmFjdG9yOiAweDAwMDMgKDY1NTM1IGJ5dGVzKQ0KCQlIVCBBLU1QRFUgZGVuc2l0eTogMHgw
MDA1ICg0IHVzZWMpDQoJCUhUIE1DUyBzZXQ6IGZmIGZmIGZmIDAwIDAxIDAwIDAwIDAwIDAwIDAw
IGMyIDAxIDAxIDAwIDAwIDAwDQoJCUZyZXF1ZW5jaWVzOg0KCQkJKiA1MTgwIE1IeiBbMzZdIChk
aXNhYmxlZCkNCgkJCSogNTIwMCBNSHogWzQwXSAoZGlzYWJsZWQpDQoJCQkqIDUyMjAgTUh6IFs0
NF0gKGRpc2FibGVkKQ0KCQkJKiA1MjQwIE1IeiBbNDhdIChkaXNhYmxlZCkNCgkJCSogNTI2MCBN
SHogWzUyXSAoZGlzYWJsZWQpDQoJCQkqIDUyODAgTUh6IFs1Nl0gKGRpc2FibGVkKQ0KCQkJKiA1
MzAwIE1IeiBbNjBdIChkaXNhYmxlZCkNCgkJCSogNTMyMCBNSHogWzY0XSAoZGlzYWJsZWQpDQoJ
CQkqIDU1MDAgTUh6IFsxMDBdIChkaXNhYmxlZCkNCgkJCSogNTUyMCBNSHogWzEwNF0gKGRpc2Fi
bGVkKQ0KCQkJKiA1NTQwIE1IeiBbMTA4XSAoZGlzYWJsZWQpDQoJCQkqIDU1NjAgTUh6IFsxMTJd
IChkaXNhYmxlZCkNCgkJCSogNTU4MCBNSHogWzExNl0gKGRpc2FibGVkKQ0KCQkJKiA1NjAwIE1I
eiBbMTIwXSAoZGlzYWJsZWQpDQoJCQkqIDU2MjAgTUh6IFsxMjRdIChkaXNhYmxlZCkNCgkJCSog
NTY0MCBNSHogWzEyOF0gKGRpc2FibGVkKQ0KCQkJKiA1NjYwIE1IeiBbMTMyXSAoZGlzYWJsZWQp
DQoJCQkqIDU2ODAgTUh6IFsxMzZdIChkaXNhYmxlZCkNCgkJCSogNTcwMCBNSHogWzE0MF0gKGRp
c2FibGVkKQ0KCQkJKiA1NzQ1IE1IeiBbMTQ5XSAoZGlzYWJsZWQpDQoJCQkqIDU3NjUgTUh6IFsx
NTNdIChkaXNhYmxlZCkNCgkJCSogNTc4NSBNSHogWzE1N10gKGRpc2FibGVkKQ0KCQkJKiA1ODA1
IE1IeiBbMTYxXSAoZGlzYWJsZWQpDQoJCQkqIDU4MjUgTUh6IFsxNjVdIChkaXNhYmxlZCkNCgkJ
Qml0cmF0ZXM6DQoJCQkqIDYuMCBNYnBzDQoJCQkqIDkuMCBNYnBzDQoJCQkqIDEyLjAgTWJwcw0K
CQkJKiAxOC4wIE1icHMNCgkJCSogMjQuMCBNYnBzDQoJCQkqIDM2LjAgTWJwcw0KCQkJKiA0OC4w
IE1icHMNCgkJCSogNTQuMCBNYnBzDQoJCQkqIDYwLjAgTWJwcw0KCVN1cHBvcnRlZCBpbnRlcmZh
Y2UgbW9kZXM6DQoJCSAqIElCU1MNCgkJICogU3RhdGlvbg0KCQkgKiBNb25pdG9yDQo=


--=-Zp3oiNN2HvEybEcSepPb--

--=-l0UJDzWOcUf4XTnZ2Kjc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmVUZ4ACgkQp5vW4rUFj5r5cgCgt+11kZH1KEil9hlWjjsu1O5r
dYYAnR2PTPPUIrV1XVj5ZVCMDHtYd9mC
=/1DH
-----END PGP SIGNATURE-----

--=-l0UJDzWOcUf4XTnZ2Kjc--

