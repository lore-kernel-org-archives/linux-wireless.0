Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:48704 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759281AbbCDRUC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 12:20:02 -0500
Date: Wed, 4 Mar 2015 17:38:05 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Chen Gang <xili_gchen_5257@hotmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bcma: Kconfig: Let it depend on PCI
Message-ID: <20150304173805.3daea9c5@wiggum> (sfid-20150304_182031_598904_E75D0318)
In-Reply-To: <CACna6rxtvwQxrsRuRt0XLAyQg5rKFf2VqNm6Vrzic5gMCbJDcg@mail.gmail.com>
References: <BLU436-SMTP3656F4A0610686DAE30BA1B9110@phx.gbl>
 <CACna6rxJ_uQHmpQS9NPs9JW=zNS4oc2-_cH6nXG0Z9CWu7iW7A@mail.gmail.com>
 <CACna6ryi4ACAfkYRDGTWkwGh9PQrj9zxcnaWjO56m1dyhmiFGA@mail.gmail.com>
 <CACna6rxtvwQxrsRuRt0XLAyQg5rKFf2VqNm6Vrzic5gMCbJDcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/pqYR9_ZT_yVARDvYnQB1zN/"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/pqYR9_ZT_yVARDvYnQB1zN/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Mar 2015 14:36:10 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> Any other opinions?

I think this is the only way to go.
In ssb we always had optional pcicore driver, as far as I remember,
so we should have the same in bcma, too.
The old WRT54G kernel used to compile just fine with SSB and without any PC=
I enabled.

--=20
Michael

--Sig_/pqYR9_ZT_yVARDvYnQB1zN/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJU9zTwAAoJEPUyvh2QjYsOS7AQALfsMrpCHSK3sPEZ3M7t5tA7
0+5Ygv6MqTdnp5kHzTWTzHmeFdFIlWUQSFOXjLe18bFCYQfIf3k6PLE+s2jERVBQ
FtQc73IYRTRZ3dfVlFxNEsgXYghOE2jFPjt9uc+ji1r02ZVYIkBZznT7H4g1JaB1
xptfywmjSEJqllFPvJApJULeZi6XARyXzv4orip2oAjLesKu/IcJUVWQL1hycxxy
chF10DVhcNgTCeyb8x8zdUa8h0CrmqG44yKAwkPEmSTAltg+n3X10mD1XISSH7yE
f4DIcOSSUs0MK9I3Yfs3ODNPj5HD8CPftXS9+6UTEZH3AlW1f2SPpeOnFfBURLJo
c5RjWUIF5V8mU1yM8iJ01eR1/2Z8+QTNOYbRZugFkeEEX8elO6ZHE+JBk/JpgyfJ
flkqgv4QBAdgEc5GzMSIpwIXh1RslEMdhW/xgmebIdFbCbLOaK3BEGAZGQ1swRIt
MxHVR3KCrt0qEhfMsGMsekEm8l+O92vHGFejCZ59fku02zlNq1OvJdxl4rGPyJfQ
t8SQvR+PQRj4+4G7VHVC9Cvkzbw0TZB9bmAs4TfzksQA+qBH09eH32zkw9NloSA2
VF3jcuDQx8pUgCwqYFK1jrffnn+vqk4/+QKVabBhCJcjWZdtv17AX/BrBjYR7Sp6
06rT31ZPh+BEsmra7+C2
=9QpW
-----END PGP SIGNATURE-----

--Sig_/pqYR9_ZT_yVARDvYnQB1zN/--
