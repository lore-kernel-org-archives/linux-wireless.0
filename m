Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:52913 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2IDHHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 03:07:46 -0400
Date: Tue, 4 Sep 2012 09:07:31 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/2] ath9k_htc: remove driver specific checks for
 interfaces combinations
Message-ID: <20120904070731.GC22841@ritirata.org> (sfid-20120904_090823_667856_8E6CA167)
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
 <CAD2nsn16-uZ0CbBXrHjUS2Rwn53OYNrLvjujmPAwGDCEbdYJxg@mail.gmail.com>
 <20120827065419.GB22073@ritirata.org>
 <CAD2nsn2CYYP2+VRX0Ph=6Vw2kTqmwRvMn+FVeS3FwMd=jvwy8Q@mail.gmail.com>
 <CAD2nsn3Q5tCp1ENsT=subp4u1GE6jazSGB=trnb6MjR8AR6m=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
In-Reply-To: <CAD2nsn3Q5tCp1ENsT=subp4u1GE6jazSGB=trnb6MjR8AR6m=w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 03, 2012 at 07:31:34PM +0530, Mohammed Shafi wrote:
> Hi Antonio,
>=20
> >> Other than that, patch 2/6 should be modified to take into account IBS=
S mode.
> >
> > yeah saw your patch, that in ath9k_htc IBSS interface can coexist with
> > one more interface.
>=20
> sorry for the delayed response(almost tortoise's pace :) ),

no worries :):)

> the
> ath9k_htc maintainer said
> TSF sync may be an issue if we have IBSS interface coexistence, any
> thoughts about this (or)
> this should be fine based on your testing. please let me know!
>=20

Well, during my test I didn't hit any problem, but since the ath9k_htc
maintainer has much more experience then me I will perform a more stressful=
 test
and see what happens. I'll let you know!

Thanks,



--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBFqLMACgkQpGgxIkP9cwcSJgCfQ9DyehlbXlELrs9vfkk9cORD
ubgAnAmh1suWRuX1n70sePLnBuw/FOtJ
=NMCm
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
