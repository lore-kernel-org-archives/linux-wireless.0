Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbXH1Rca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 13:32:30 -0400
Subject: Re: [PATCH 1/5] Net: ath5k, split hw into hw, phy and initvals
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070828171034.GB29343@infradead.org>
References: <2713029743177393055@pripojeni.net>
	 <20070828171034.GB29343@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ff8Wojp2HLS8tUDrzQeA"
Date: Tue, 28 Aug 2007 19:33:30 +0200
Message-Id: <1188322410.7837.113.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ff8Wojp2HLS8tUDrzQeA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 18:10 +0100, Christoph Hellwig wrote:
> On Tue, Aug 28, 2007 at 11:58:52AM -0400, Jiri Slaby wrote:
> > -ath5k-objs		=3D ath5k_base.o ath5k_hw.o ath5k_regdom.o
> > +ath5k-objs		=3D ath5k_base.o ath5k_hw.o ath5k_regdom.o \
> > +			  ath5k_hw_phy.o ath5k_hw_inivals.o
>=20
> And while I'm at nitpicking :)
>=20
> ath5k_hw_phy.o should probably be ath5k_phy.o by conventions used by
> most drivers and ath5k_hw_inivals.o mights aswell be something like
> ath5k_init.o

While we're at names... I personally much prefer a new directory ath5k
and then ath5k/hw.c etc. but it seems I'm pretty alone in that. But here
we already have at least four files now.

johannes

--=-ff8Wojp2HLS8tUDrzQeA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1Fxq/ETPhpq3jKURAnvEAJ9vkHxIudP6g6LlLrO1+8r0duaMIACeISEm
J3YEmM0nMpLHM4upB5Ygxdg=
=06kl
-----END PGP SIGNATURE-----

--=-ff8Wojp2HLS8tUDrzQeA--

