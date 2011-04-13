Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:50132 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757825Ab1DMIxr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 04:53:47 -0400
Date: Wed, 13 Apr 2011 10:53:37 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
	"John W . Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
	Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH v2] rfkill: Regulator consumer driver for rfkill
Message-Id: <20110413105337.0e106fe8.ospite@studenti.unina.it>
In-Reply-To: <1302608488.3639.15.camel@jlt3.sipsolutions.net>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
	<1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
	<1302608488.3639.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_Apr_2011_10_53_37_+0200_rl_=nQSEa+t+5zJn"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Wed__13_Apr_2011_10_53_37_+0200_rl_=nQSEa+t+5zJn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Apr 2011 13:41:28 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> > +	dev_info(&pdev->dev, "initialized\n");
>=20
> Is that message really useful?
>

I can print the pdata->name here as well as an excuse to keep it,
reality is that I just like visual feedback in dmesg when a driver has
been loaded.

> Other than that, looks good to me.
>=20
> johannes
>

In another message you said that the comment in rfkill-regulator.h
still seemed a little wrong to you, would you elaborate more about what
you were referring to?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__13_Apr_2011_10_53_37_+0200_rl_=nQSEa+t+5zJn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2lZJEACgkQ5xr2akVTsAFCuACcD7DJpTaZ91yuxPAKX/HKd/hS
u/UAnAlQzA8g0Apy/LGU/hcwFRMsGkj2
=C7Hz
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Apr_2011_10_53_37_+0200_rl_=nQSEa+t+5zJn--
