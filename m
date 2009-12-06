Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:33502 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbZLFTcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 14:32:13 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/4] nl80211: Add new WIPHY attribute COVERAGE_CLASS
Date: Sun, 6 Dec 2009 20:32:18 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net> <1260125366.3461.24.camel@johannes.local> <200912062028.52470.8an@praha12.net>
In-Reply-To: <200912062028.52470.8an@praha12.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6642962.OFaqlncx3s";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912062032.19096.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6642962.OFaqlncx3s
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 6.12.2009 20:28 Luk=C3=A1=C5=A1 Turek wrote:
> I looked at the rndis driver, but it seems it could be configured via
> wireless extensions only, it does not define cfg80211_ops at all, so I
> think it cannot be managed via nl80211 and I don't see your point there...
Sorry, I looked at some older version of the driver...

Lukas Turek

--nextPart6642962.OFaqlncx3s
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLHAbDAAoJEEBjvk/UOfYw7DMQAKYwQDYopqNmP/IwbyHN+0/4
+SNpbh8ki2icRQ53Qp9/toc93jbenaUhugL4ATjnzUTaIoan6yv4h4TX10yKv5cH
U3nPL5O5dRdlsV8rFhIzEdTCDQBl3FqXYduiv8nzA4QbAx3wuIIq7f3jvgU/2Vo1
RsWkEhp8xl+D+Eq1sul8d/K2Ghfcs3+bsxPiRdXdq5WuRh49UivAVs5ok1jzGgoO
o5/gv7DajCFcfWU2iEMJ3CrfMxE01+79QYBgutrPqBo/DFQzrsNm/9tBM1S3LF20
h9eGj+RQQFRp/Gj6hy7ZOgVs5pDQQaw3TVTQqyVUq+xK6+N4B0/5+iWsg3vg/RnE
FSPfTKxCe/PcUyUjcp1+bUTG/pVvYB+9YZ1/OgwD2aksYbqZdPbMT0uDhSzP2Q4/
WcxOJrd2shtsGsx14NFwR2H5a5eCm4sp8/57kxptEL3KIKq63zCErUlcmFZ/z72Z
whJB/yEv0Osh4YiTUvclqyfGuxY1AM1zDlIE0EcmatutAk6s6x8RY6v+c/hqyhfl
aNTuR1YzwLi+tyfwSiGBLbPqB1XaUZGCwMKQbu5JV77HfeuxV0Yyj4sFBA1ULPtJ
D89iNT6WcYLeQ/bi1O3jMI/s8boounJh+AicZvX9PvalYQyW2zoLvucnKrStCd+W
AZCXoBvR2vPOn/tpqwEy
=xcdW
-----END PGP SIGNATURE-----

--nextPart6642962.OFaqlncx3s--
