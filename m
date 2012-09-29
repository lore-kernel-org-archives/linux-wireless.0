Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:34572 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2I2Jby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 05:31:54 -0400
Date: Sat, 29 Sep 2012 11:31:18 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
Message-ID: <20120929093118.GA3022@ritirata.org> (sfid-20120929_113243_550540_8A53F476)
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
 <20581.2614.43943.601901@gargle.gargle.HOWL>
 <50652E56.10303@qca.qualcomm.com>
 <20581.32544.134606.56158@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
In-Reply-To: <20581.32544.134606.56158@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 28, 2012 at 04:12:40 +0530, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
> > oh yeah, you are saying that we will have some issues with IBSS
> > coexistence with other modes because of TSF sync.
>=20
> Yes, this is a problem.

Is there anyway to overcome this problem? Can we bind the single TSF to mul=
tiple
virtualTSF? or must the device somehow support us?

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBmv+YACgkQpGgxIkP9cwdDNwCeP8lEog9PLFP5lh0cEl7Vc1Fa
aMgAn3vT0YxTWisSoj9N5wgDq5CzuQGn
=1NAS
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
