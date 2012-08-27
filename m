Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:36188 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2H0JnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 05:43:11 -0400
Date: Mon, 27 Aug 2012 11:42:56 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/2] ath9k_htc: remove driver specific checks for
 interfaces combinations
Message-ID: <20120827094256.GC22073@ritirata.org> (sfid-20120827_114315_128676_0E31D842)
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
 <CAD2nsn16-uZ0CbBXrHjUS2Rwn53OYNrLvjujmPAwGDCEbdYJxg@mail.gmail.com>
 <20120827065419.GB22073@ritirata.org>
 <CAD2nsn2CYYP2+VRX0Ph=6Vw2kTqmwRvMn+FVeS3FwMd=jvwy8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
In-Reply-To: <CAD2nsn2CYYP2+VRX0Ph=6Vw2kTqmwRvMn+FVeS3FwMd=jvwy8Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mohammed,

On Mon, Aug 27, 2012 at 02:45:36 +0530, Mohammed Shafi wrote:
> Hi Antonio,
>=20
> > Your patch is ok. But, at this point, should patch 2/6 and 3/6 be merged
> > together?
>=20
> an order of interface combinations advertisement(2/6), followed by
> removing specific
> checks should be fine right ?

In my opinion this is correct. But maybe Johannes has some arguments agains=
t this
order?

>=20
> >
> > Other than that, patch 2/6 should be modified to take into account IBSS=
 mode.
>=20
> yeah saw your patch, that in ath9k_htc IBSS interface can coexist with
> one more interface.
> The standalone limitation exists in ath9k too, not sure this is a
> limitation to beacon config
> for ath9k & ath9k_htc, I will just confirm. If its fine i will resend
> the v2 version signing off both
> of our names accounting IBSS mode too.


fine with me :) Thank you!


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlA7QSAACgkQpGgxIkP9cwfxdQCePZWsy/J7W/Mxo0WLtZDPeVxm
ZdMAn3nfCewdXsqNjKLPO6y9e5UtxuvH
=j7uQ
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
