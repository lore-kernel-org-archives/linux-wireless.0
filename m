Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:40079 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3CWRoQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 13:44:16 -0400
Date: Sat, 23 Mar 2013 18:43:57 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Chris Vine <chris@cvine.freeserve.co.uk>, isedev@gmail.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: A fix for DMA transmission sequence errors
Message-ID: <20130323184357.6b4f2037@milhouse> (sfid-20130323_184429_667635_BDE0BE32)
In-Reply-To: <CACna6rwAOgvbd6z2ckZ6uW=8wOw-+YMT_wc4FC+ZgAaAhCgpwQ@mail.gmail.com>
References: <514a07c7.ZQz6MhmMaq58WJlA%Larry.Finger@lwfinger.net>
	<CACna6rz75ecyy5CdaJfi=dRjrTh_Rg793Ub+-0QdVnCZNyV+Lg@mail.gmail.com>
	<20130323113517.01906b0b@milhouse>
	<20130323155355.0a1752f5@laptop.homenet>
	<CACna6rx+sCrg1fB-6XfYcSWczu6Mtuvz75FOHbbx3YdPe+U5sw@mail.gmail.com>
	<CACna6rwAOgvbd6z2ckZ6uW=8wOw-+YMT_wc4FC+ZgAaAhCgpwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wOGZA/PD81nOgcoT3WtFKxA"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/wOGZA/PD81nOgcoT3WtFKxA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Mar 2013 18:28:33 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> > Could you try changing
> > B43_DMA32_RINGMEMSIZE
> > from 4096 to 8192 in dma.h?
>=20
> Blah, ignore that. You're card has 64b DMA, not 32b :|

You could try playing with the constants anyway. Maybe something
interesting happens.

--=20
Michael

--Sig_/wOGZA/PD81nOgcoT3WtFKxA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRTendAAoJEPUyvh2QjYsOSHUP/jbEeFj+Ochg1csifOo6i2sD
zHlFkzWRNhrZPF+X9hfmA8P0Nae+8rhSWOzTIA+fK9wSBAvSbgALAZRQnE3fFYOj
GUieOkH6UG2TESJ+fJdZW5XF6188CMNIhxssFELP0SVAwU6LrdcVuUolv5wmS5iM
l4UHxasMy48d2wQE3h/ijAHcz3ycT0U1praLbndADkk1fcADY7frRB3z6ge+eO5W
YnMJbzB53F5Zaa0NV5/aVYsqYBJ67bBMB3H1MoscgWWl1teoMnpdqjcVjuXrE03y
OtUeK1rfK3PxUoTobC0QTM3jUQmSb+w3E6sJIdcarueaPtTL6q4b6aa7hm5FA+uS
vssL/be6/5ujxU+GWrQyk79NDGUY5iCwIe2/b1jOxdO1On79vmlntr1Wpt+d9BC6
UuvxAzIHyG7ncckE2QjCCdMCmbgFOvNgyuS5j9uqS5Fbyw7Rv3KYdlTxT7jHVDEx
RnWSFqeAkakkZCX5vcPpLvuRoVX5iKrLBrHzfZmeWU9fSzxLDqkLlmh93djSVVgV
eJdo5iP919nS/b6qL6Ik1jwACcOeJP3RYxhNnG3811UtREOhCjRtgfWkl6QbERTZ
I+8EY8DYR/AXERDgDcdMUmbNvPi6+OeRapUBclS2qY3ZDc60JH1IAn6j3TQbkzj+
5WaeyN3iwKcN2cpNmijg
=dOG0
-----END PGP SIGNATURE-----

--Sig_/wOGZA/PD81nOgcoT3WtFKxA--
