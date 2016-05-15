Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:53659 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbcEOOjb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2016 10:39:31 -0400
Date: Sun, 15 May 2016 16:39:06 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Adrian Chadd <adrian@freebsd.org>
Cc: b43-dev@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [b43] don't unconditionally fall back to CCK if the rate is 6MB
 OFDM.
Message-ID: <20160515163906.3d64d8fe@wiggum> (sfid-20160515_163935_213974_B8431AE7)
In-Reply-To: <CAJ-Vmom45Pb9X_1Zw6VdszZAiizZUUd=HbEFw0hFMmPFFSNbpQ@mail.gmail.com>
References: <CAJ-Vmom45Pb9X_1Zw6VdszZAiizZUUd=HbEFw0hFMmPFFSNbpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ZbbUvluymjab9Vif1=y33RK"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/ZbbUvluymjab9Vif1=y33RK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 15 May 2016 07:23:25 -0700
Adrian Chadd <adrian@freebsd.org> wrote:

> @@ -438,7 +446,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
>=20
>                 rts_rate =3D rts_cts_rate ? rts_cts_rate->hw_value :
> B43_CCK_RATE_1MB;

I just noticed that this is incorrect for 5GHz, too.
Maybe there are more such bugs.

--=20
Michael

--Sig_/ZbbUvluymjab9Vif1=y33RK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXOIoKAAoJEPUyvh2QjYsOG4QP/RZBEihC+1Fdrb6whVZfWvtX
5rpEUtKi6FwlCwz8UnCDn3eOTGoZJdcXNKXFjvLz0q5CoM33/abFh47JM81I3lLb
DK5NZupnanedVMEaQuECi+RFxaAYQ0QOHAglD+wdksIEru7sPVpXYzZAMMZ7OYAn
Yr23dgZnYjKgUw+y914OGaB5YRmbA63yIUexjI6Y6iGIdjQ6Uoev1qAJhrzwzvUy
rUEAhpCBpMys5fU+v7oF7gEUD8XOtsDnj0iRWPtZh6qCBmUOISv8SG1xSHalguFs
r4kxBgXRmPFpvT2vSp94UjZsBlI/snzQaoumEL8aTEWKDqGsi7oxAlcT1kLAWJBX
nkvNNy5y8fa9+q8QP0xXuChviu5V6f6+M0g//UZT5FsJt7vzSdx3ugstezumhTcz
tWUQSDzfbBt+nI4EsV6rmDXxLFnqwdtwSSRN9SF0Ar2Lo5EHxh1x9uaf7faqoeL3
hdUAf+Heu9bkHO7uKH0A1Thyb1ZsSFHAJkSt9lEB802x/lWaRGVDsui3IeRoTHt5
nOuItF9SldAwDTH8Dgwml2gpJtM5gaMqinUkBRKQLlYO04ieuYN5lG0ZivDdoBnb
D7kpEsclFDdKjXXLh6MaP46v2ymkSLJ8j38faU5p1Hjey3NbCMoC5z0fyB2YFnnU
YuK6ePPx5fiEmSq4FJEi
=nWIf
-----END PGP SIGNATURE-----

--Sig_/ZbbUvluymjab9Vif1=y33RK--
