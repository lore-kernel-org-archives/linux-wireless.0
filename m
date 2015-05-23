Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:34739 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439AbbEWKld (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2015 06:41:33 -0400
Date: Sat, 23 May 2015 12:40:38 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix EFUSE_ANA8M map value
Message-ID: <20150523124038.17417873@wiggum> (sfid-20150523_124238_998521_CF10381D)
In-Reply-To: <55600CEB.5080703@lwfinger.net>
References: <20150521214421.15983b0a@milhouse>
 <555E5433.7000904@lwfinger.net>
 <20150522070035.711c6195@wiggum>
 <555F8FDC.3040609@lwfinger.net>
 <20150522231300.200a2e00@wiggum>
 <55600CEB.5080703@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FB3BEJuJ1NPYGieSwtLJ_8S"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/FB3BEJuJ1NPYGieSwtLJ_8S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 23 May 2015 00:15:23 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> No, it is able to scan and connect with the vanilla kernel, but it is not=
=20
> terribly reliable with about 25% ping loss. I just got a report of a regr=
ession.=20
> Kernel 4.0 fails whereas 3.19 works. I have been seeing a lot of patches =
from=20
> various sources. I thought they were OK, but I will need to bisect.

I tried with 3.16 and 4.0 based Debian kernels. Neither worked.
I use the firmware provided by Debian's firmware-realtek package.
I have two of these devices, so I think the hardware should be ok, unless t=
hey are broken both.

When I first tried to use it, I forgot to install firmware. It tried to loa=
d it, then some 'alternative firmware' and then froze the system partially.=
 I guess there's some unreleased lock or such in an error path somewhere. I=
 didn't check this, because it didn't seem too terribly important for now.

I will also try your driver from your github repo soon and see if that make=
s it work.

> Some days I am sorry that I ever heard of Linux. :)

Retired, but still out of time. :)

--=20
Michael

--Sig_/FB3BEJuJ1NPYGieSwtLJ_8S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVYFkmAAoJEPUyvh2QjYsOymEP/iakGUK7U9nzY2iU4CpBrDcd
s3WmR34lJgxDuVt96VU1EbSpYbB7/Bctfjf0MdYvxQ3Xx+l967GtwsvUyfUGT75f
GDewyqw5oOb1I1GYW94tVDSQpFicm0ma7nWKPfwBu/klOihq+fgWUsMPSMLKvssX
GE/TNpQcFq3ZtF18tfC/k3dnPBX7E80/J3CfSUFNyXHCFypjt0CGXlb/G7LSNpgu
iF0r2oK258+AMexLRdkkl19TWej+KzHj35dpcovVZrTlkUxpAERNEXf1bGMNGgN7
Ihw/P5UZNeuBgAq1pd3SMTNrezRG1idqibd5W3Cau4ALTQZBlfepjvgfqKPvYkB8
2ZLXmw1MzT7l3/qxEu0WrdBChTqvzM78ObebBqDNSkN4gbVgu+4w3pWhnTELsuEI
vJoEwYbQlzAlgG3l0KOq2bNe5GmsdjJAdw4M2X90LQiImcFBPrLmnT9Ldn/5tCPh
W/R2r6+O5Se4bTV2KGNmREy6Q9y6vZje5JL7BCSzdlfAQCusdKJ5lUU5h7Kz6mtn
jWiV6CGXl3HyC/FIKV++bhtfV2mlS3BiFuJMPq9JCKbvjlr4BpqqdknERcrHMR8L
4UJJQgZfAByr1KDyRduFzftu4XUC8BU8mRDdrjbAjfjq77P2xz6pQQqSNKQbvXU/
p3O/TfR2qBx8/pykC9Yh
=UoHG
-----END PGP SIGNATURE-----

--Sig_/FB3BEJuJ1NPYGieSwtLJ_8S--
