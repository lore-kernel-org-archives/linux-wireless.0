Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49464 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab2BSTum (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 14:50:42 -0500
Date: Sun, 19 Feb 2012 20:50:16 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com
Subject: Re: [PATCH 04/11] ssb: add ccode
Message-ID: <20120219205016.742a4bad@milhouse> (sfid-20120219_205049_433655_62B75713)
In-Reply-To: <4F414D63.1070409@hauke-m.de>
References: <1329676345-15856-1-git-send-email-hauke@hauke-m.de>
	<1329676345-15856-5-git-send-email-hauke@hauke-m.de>
	<20120219194923.566f3fe8@milhouse>
	<4F414D63.1070409@hauke-m.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3Vd8gdXC+SmlcdlAXIlH2O8"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/3Vd8gdXC+SmlcdlAXIlH2O8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Feb 2012 20:28:35 +0100
Hauke Mehrtens <hauke@hauke-m.de> wrote:
> >>  	u8 country_code;	/* Country Code */
> >> +	char ccode[2];		/* Country Code as two chars like EU or US */
> >=20
> > This usually is referred to as "alpha2". So we should name it like that=
, too.
> I can not find any references to "alpha2" in the spec

http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

--=20
Greetings, Michael.

--Sig_/3Vd8gdXC+SmlcdlAXIlH2O8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQVJ4AAoJEPUyvh2QjYsOgNEQAMcX1ap8zLbbNOcG2gH+zZz9
9YzgeKgSyjkOIJ5mJYPIEStNMPWXWNZuf5D3lxCMZsnQt9pOeTMGR/QjHzmE4TqZ
FZi33q/DSClvpsY5OyDlHPrLqtfjSdKsjd1L/ihoV2yBNNLKviPdpXQowZjgVvur
K2ge+swi3eMIR8VEn7nbwyAGlc76SoPWpnpVdlgHxYLhz5CwRCYoa5W6rjEuTCxU
d1z+696OpmrqhBS3cT/7GD3HIE6cXL1UknFD40uMAmcdWDKMWFuSbrbIA61YsIKH
wrakpxRhY1lfEeMQ1fZGslSBIGYNR1LdVyveLcPwxPGSV+/86I1e4VAxo0OzlRfi
NG5Z6CTC0TNZacKR7OZMEmqs7vp6f9LMG2UHvFVdWfL7RsTIIutXD4sjl3RGNHZ3
8MG6I9uqQTXY4BWwLqLQceKeMttAaXqePhRzh8NcAgkZx6uTay0wIff536TVMto5
qxhRU+4xTb+sdgUYo1YdH/VGqjMr0bS/UqeAjRCotp6EZIs3TPpVncDtRZq1UF1U
ZPVbWNfALbr1V5iYPYYcEy93okNlfbUC416uMXTI9MmPg7XKTHVpFH0uKloJrJqU
iMCpwTFGs4CZ0xZegz6YRMz0OamEwxxVVf4mfqQln/0XjJOErdoos8k/SjS5KtfV
VgBbTcLIx8iVNrkZn6fC
=ncAt
-----END PGP SIGNATURE-----

--Sig_/3Vd8gdXC+SmlcdlAXIlH2O8--
