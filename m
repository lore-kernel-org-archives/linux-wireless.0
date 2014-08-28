Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxin.vub.ac.be ([134.184.129.112]:21550 "EHLO mxin.vub.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaH1Mnj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 08:43:39 -0400
Message-ID: <53FF21AA.5040406@telenet.be> (sfid-20140828_144341_938509_296194A5)
Date: Thu, 28 Aug 2014 14:33:46 +0200
From: Ruben De Smet <ruben.de.smet@telenet.be>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for someone with BCM43227 and (maybe) compilation skill
 ; )
References: <CACna6rxVjnpMgQx9+d_LbROYNnnjnuMEGo-38MPwjsPtxYdN8w@mail.gmail.com> <CACna6rx+EkoCPQ06qDTbaDFEJ1hrn_CYSbrPmosF0ikhkqDxpA@mail.gmail.com>
In-Reply-To: <CACna6rx+EkoCPQ06qDTbaDFEJ1hrn_CYSbrPmosF0ikhkqDxpA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="qpuxQb8V0OGO7CbAR8DlBKK1SaW633rx1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qpuxQb8V0OGO7CbAR8DlBKK1SaW633rx1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/03/2014 02:50 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> On 3 July 2014 14:32, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:=

>> I want to add support for BCM43227 in b43, however I need help of some=

>> BCM43227 owner. Well, I could buy one by myself (less than 10$ on
>> eBay), but I don't want to wait a month to receive it.
>>
>> So I need someone with:
>> 1) BCM43227 ;)
>> 2) Kernel with CONFIG_MMIOTRACE=3Dy*
>> 3) Broadcom Linux STA driver 6.30.223.141
>>
>> So? Is there anyone around with BCM43227 willing to help?
>=20
> I'd need someone to:
> 1) Disable NetworkManager & blacklist wl
> 2) Make a cold boot (power off for 3 seconds)
> 3) Run attached script
> 4) Provide me /tmp/dump.txt (preferably compressed)
>=20

Still needed? I have
03:00.0 Network controller: Broadcom Corporation BCM43228 802.11a/b/g/n
That is one iteration higher.

Ruben

(I'm not subscribed to the list anymore, so please keep me in CC)


--qpuxQb8V0OGO7CbAR8DlBKK1SaW633rx1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT/yGqAAoJEPgmWogSE9wQtzIH/iTAbPC1Eqjefa9uO//l6cJh
fOw3caV8jSxeN5FpBhl72V9KIHFVY3jeUckDa9Ug4YfvO4QZJH0xFO4Wue0pbKLN
40rBB7ClNa8XeJDAp7tkW648OHuAM0A0JweLlTtV4Q7GnBqCwQiBswZEarDTJI2a
8n6OrrSsfj8EPsKbVz0wWw7xpMyERacduryGtwqbLSAsRabF5ZSAt/WeWH3mzL4F
XkZBM3HEyEran62ql2e51c6Owg/TV/BeRf+QOH4NO89sTAOkohKUgewe5YERfNHr
nvxERakWWs6+jsUf4CQ6Fc4zTaDYiwOQ/a8vJXjGbXquLetO3h2q22MmFWFAMbs=
=21lA
-----END PGP SIGNATURE-----

--qpuxQb8V0OGO7CbAR8DlBKK1SaW633rx1--
