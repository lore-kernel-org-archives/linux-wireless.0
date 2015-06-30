Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:37063 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbbF3PQm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 11:16:42 -0400
Date: Tue, 30 Jun 2015 17:15:57 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Nik Nyby <nikolas@gnu.org>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: Fix typo in function name
Message-ID: <20150630171557.17782835@wiggum> (sfid-20150630_171701_590133_8CE9906C)
In-Reply-To: <5591F0F4.3010008@lwfinger.net>
References: <1435625147-23535-1-git-send-email-nikolas@gnu.org>
 <5591F0F4.3010008@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1AYQ4R+WOyzp5OHQHqus6x."; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/1AYQ4R+WOyzp5OHQHqus6x.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Jun 2015 20:29:24 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 06/29/2015 07:45 PM, Nik Nyby wrote:
> > This fixes a typo in the "b43_lo_g_maintenance_work" function
> > name.
> >
> > Signed-off-by: Nik Nyby <nikolas@gnu.org>
> > ---
> >   drivers/net/wireless/b43/lo.c    | 4 ++--
> >   drivers/net/wireless/b43/lo.h    | 2 +-
> >   drivers/net/wireless/b43/phy_g.c | 2 +-
> >   3 files changed, 4 insertions(+), 4 deletions(-)
>=20
> This patch is OK; however, can there really be a typo in a function name?=
 How do=20
> you ever know that the author did not mean to use a name that looks like =
a typo?
>=20
> Please be careful with these.
>=20
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


Nice finding.
Me as the original author of that mess gets a brown paper bag and acks
this.

Acked-by: Michael Buesch <m@bues.ch>


--=20
Michael

--Sig_/1AYQ4R+WOyzp5OHQHqus6x.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVkrKtAAoJEPUyvh2QjYsOi4sP/0X7TBhA6VHybUlRuvL0t0KK
icv0MyLmRZV7RoEaXFt4V39KSPPhurJxgChOlnpwaVNqRBTAyWNG1MvTp4qoSqH/
8QHWq0P5dwUkYxTMfNWE3xdoRcB2NjTHfE0lj8N8cjhAxm494qkNhaWBD04hTemc
3PzOY1xtp3E29ALY+w+EgiagUwQgta31IU4ohTzHLvSzVUoqAiS9PjBDcMn+wZpV
0VwQkjNk1q8rgdJeFcWhlt8a8sz3dz4g3w7/mowE2YUJcYSLkC5wbbpR6GyQsclV
xNhrbyVTg4xOagw4roGSHoU5oRyoOzEdbR4q6aXHYtSKL7/NdjlyRiQ4xvvd+A6q
4zskT0DRuUL4NIoPkfguTnIs6D9D3npSE2o4U98YIxjkLY6VIE1nuXb21iBQM5d/
6ZvZ0iL7NelwasEFfiBS4EbIvJTC/BaY1lbbzVn4iRAAsTnvgX/GOEhy3VNcXP/9
e0pSoD5veYzYnRf1/yKvxXaqUDqn5ahGyDCBmt/6AzeUkSvCYCaGCcRrMqVXc3nf
W8yA54+VDpCUn/eqdh+3xwtm1jXeCNU6JvMMG5ZRwiTqHyf6PqJzhRRcIyV0PDdD
IJKcpMg43xBm4BUJECjXfFzm+ptDCX/F8BtR3s4zYOp1F5dZcsbEFEHxzVk4YVeG
NcLEcbTHYcwHGhMVsBlL
=yD4m
-----END PGP SIGNATURE-----

--Sig_/1AYQ4R+WOyzp5OHQHqus6x.--
