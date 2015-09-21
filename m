Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33328 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757147AbbIUQ0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 12:26:43 -0400
Date: Mon, 21 Sep 2015 18:26:22 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH][RFC][RFT] ssb: pick PCMCIA host code support from b43
 driver
Message-ID: <20150921182622.0727f224@wiggum> (sfid-20150921_182646_294552_0B32CA83)
In-Reply-To: <56002CE8.3080605@lwfinger.net>
References: <1442826259-6270-1-git-send-email-zajec5@gmail.com>
 <56002CE8.3080605@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9sLDFmMKtvWVa0rkPsKMg_R"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/9sLDFmMKtvWVa0rkPsKMg_R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Sep 2015 11:14:32 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> This patch has been tested on PPC architecture with Linksys WPC54G PCMCIA=
 cards.

Are you sure that this really is a 16 bit PCMCIA card and not a PC-Card?
If it shows up in lspci, it's not a PCMCIA card.

> It probably does not matter here, but I prefer that hexadecimal constants=
 in=20
> device tables contain only the lower-case versions of a-f. That makes sea=
rching=20
> for such constants with grep a lot easier.

I prefer coffee over tea. That doesn't make coffee any better, though.

Is it really so that the rest of the kernel only uses lower case here?
Grep also supports case insensitive regexes, if done correctly. And if
not everybody uses lower case here, you'll have to do that anyway.

--=20
Michael

--Sig_/9sLDFmMKtvWVa0rkPsKMg_R
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWAC+uAAoJEPUyvh2QjYsODZAQAMxBUN9e54azZ8OrF6h0XpUC
suKMHE7P963j1emzNxScBjdTxVNwCt/6099jdzRRb23QanOuOfXm4N1xHe4BVYo2
ru27Jr01oLmkZLiESZWfI6o1SU2nkMkd+4SI2XDju0lkCmVixWTGWYWgj21IAwpe
/uyeyanae2adreKpNWbfOzGrEi28c5zYlTMnkz4EEIlNXyTvxOryle47yMI6HnlJ
/ldD7r1NhNnGJxnLlygvTRPq0+3dfDiDZ+Vk6XXttmAGFf6P61IlbY9tN4p3a4p3
AcHLBcNhRyP2rFIO22ygTFP2QrXN457O4+4Clui3iufk/8fKeqAEvt4LzvWJQGLH
9kRbZIOeLMB7W3HGPNqLv7Biibw4v0OMnzLNowMfw6E7ClFeDrxT3zLSU583sdQ4
Zm+IV/2pPKjGvzLdAPYUQFkypXUuL+NDGzkD4tb3oFiEEoALmlOijkW3/p+ygzF+
9rhQdFPDqJGHd+hBl1PUX5Or9RlCTDPTRkQJJQTkSWe1Du8kSIHCQVbBq8nrrim4
9qHDXDNbitBFMKS3Mcxi7P5i1kuAA3WqwYsHGQcWRdunYCDpEk0CtaYir6KyNy4B
KAVgEnM/DVGVO8j2kCKAPzfr0jk5xqrhhN9cZ9JsUuDGlQZokLWJj8HV3l0K8w78
2pGxB9+LeDtWf116hczc
=PBd0
-----END PGP SIGNATURE-----

--Sig_/9sLDFmMKtvWVa0rkPsKMg_R--
