Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3FEO1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 10:27:23 -0400
Message-ID: <51AF4AA7.6050005@blackshift.org> (sfid-20130605_162726_425424_43B2F9C5)
Date: Wed, 05 Jun 2013 16:26:47 +0200
From: Marc Kleine-Budde <mkl@blackshift.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k_htc: fix skb_under_panic error
References: <51ADBC01.6090202@blackshift.org> <1370371064-6903-1-git-send-email-linux@rempel-privat.de> <CAGXE3d9p7zkwfNJBJvPMc8XaKnb009pHpCXYweDjK4tv6PCkuA@mail.gmail.com>
In-Reply-To: <CAGXE3d9p7zkwfNJBJvPMc8XaKnb009pHpCXYweDjK4tv6PCkuA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2ELDMVCQQWCBQPJNIGQHV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2ELDMVCQQWCBQPJNIGQHV
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 06/05/2013 04:24 PM, Helmut Schaa wrote:
> On Tue, Jun 4, 2013 at 8:37 PM, Oleksij Rempel <linux@rempel-privat.de>=
 wrote:
>> This error seems to be really rare, and we do not know real couse of i=
t.
>> But, in any case, we should check size of head before reducing it.
>=20
> Mind to try the (completely untested) patch against wireless-testing in=
stead?
> Helmut

I will do, however I'm not in range of that USB wireless adapter for
about 1,5 weeks.

Marc



------enig2ELDMVCQQWCBQPJNIGQHV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRr0qtAAoJEF5D1i44JRMaFvMP/2RP+cS/FuHeIr3Cj3ak85Gp
1LqX5OnmS4FM4myFs0cOYenMus1NLWhYekPD7rj1v2STkBlsN+xhSHPnr6r3vCjO
etxh8Zh70Ab3k+VwG60EgvvL18ahmHnWKIyPFvZAhAZPh9M2j4zMW/BgyCH4015O
Y7hpIHhG7HKZ+zgD70nfRQJ/4V6tBmsK4ydPwga962mcaKUYyJOADbWlgO1it2de
F2mHVUM2xmqIHyCJNlcIXXmkM7fnNfLG6F5di5/UAua7YBb7DNeDruYhsvBQD6aE
5kZQ3LCQpLJDdBRc51cQkJzNjMcszzLD8t8q4ggONf8DgV9w3Mt24dSB0X73kJly
oarQtrFrRyRzXHfyLWlHeWZJlfhdWkH07v5gGefvJLoBgilBTfVT0L5CJIIbrD17
0foXLZ4OUMN6oMgrKwcVYwsBUf/PsikYJeWZcrXlShjUiThAMYZ+fQfBcgZ1MN7K
wY21NL12tfHRZHUTR1FMGVEwuqB4MYoJzVoSxTBSrk/OjI9Jej4ZfKzQW9DdsdyI
ZcMBDd4MBY359Lnp5GPNpN++Bwqx+o0IKmpgbOCSIaxRDE9d0JDgHGaC6Q9fU45T
gFlEj2UYyPNNT67bjCZ+h6CGee5sHCyMbmLfxqrJqV0CKrqZfrRM6K7HuiilNbvx
fmfGAZEj33tJZx3GuYYm
=tRUD
-----END PGP SIGNATURE-----

------enig2ELDMVCQQWCBQPJNIGQHV--
