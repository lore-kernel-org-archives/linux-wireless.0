Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:55609 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2I0QCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 12:02:48 -0400
Date: Thu, 27 Sep 2012 18:02:19 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
Message-ID: <20120927160219.GB16625@ritirata.org> (sfid-20120927_180251_948173_203D2262)
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
 <5064767F.8050701@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
In-Reply-To: <5064767F.8050701@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 09:23:35PM +0530, Mohammed Shafi Shajakhan wrote:
> On Thursday 27 September 2012 09:22 PM, Mohammed Shafi Shajakhan wrote:
> > From: Antonio Quartulli <ordex@autistici.org>
> >
> > Advertize allowed VIFs combinations to the cfg80211 sublayer.
> > Other than that, practical tests shown that ath9k_htc devices allow an
> > IBSS VIF to coexist with VIF set up on other modes, so advertize
> > that to. We can also further add p2p/mesh mode to be advertized
> > in the combinations allowed.
>=20
> Antonio tomorrow evening i will just do a sanity test and send these
> stuff as patch. thank you so much for your patience!

Mohammed, great! Thank you for your rework!

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBkeIsACgkQpGgxIkP9cwfAJQCfedFiXH7NVS9mdB0YJSwW6w4o
AIkAnRW+I0weD/k6yOMGaWiYa9npYh18
=px+h
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
