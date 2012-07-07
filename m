Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:41806 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2GGS7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 14:59:41 -0400
Date: Sat, 7 Jul 2012 20:59:54 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	ath9k-devel@lists.ath9k.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: Re: ath9k: Problems with diversity on AR9330
Message-ID: <20120707185953.GA3911@pandem0nium> (sfid-20120707_205945_292265_4D26D26A)
References: <20120706125043.GA23189@pandem0nium>
 <CAD2nsn1=PDBTRXumDh93DzvmFcBnyFeLD-5c5oSJmv3OO6LWGw@mail.gmail.com>
 <5244861.J1Tyef1FCX@bentobox>
 <4991617.K7XqcvhjBY@bentobox>
 <CAD2nsn2m1wizCw6WY-k0KRY2NJTaqqxdoA_d_+K-kqrhw+FZ3w@mail.gmail.com>
 <CAD2nsn1-ZrKQxTYc_YZ6ETxovD9o7=Ygd2j2MxJiq8Vsiu19QQ@mail.gmail.com>
 <CAD2nsn2_16KcE2g5gysc5XwVtns5jAwD+doRzqTQdsim8xbchQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
In-Reply-To: <CAD2nsn2_16KcE2g5gysc5XwVtns5jAwD+doRzqTQdsim8xbchQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Shafi,

we had this checked out before, the EEPROM/EEP_ANT_DIV_CTL1 value is set to=
 000000c9,
so bit 6 and 7 are on (as checked in this function).

Cheers,
	Simon

On Sat, Jul 07, 2012 at 04:02:12PM +0530, Mohammed Shafi wrote:
> > further i check with the CCK/DETECT and MC_GAIN_CTRL in ar9485, it  see=
ms to be
> >  ar9003_hw_ant_ctrl_apply CCK_DETECT 80be6788
> >  ar9003_hw_ant_ctrl_apply MC_GAIN_CTRLL 13ef0200
> > will check it out whats the one bit difference in CCK_DETECT
>=20
> also could you provide the output of the attached patch, i would just
> check the diversity
> configuration
>=20
>=20
> --=20
> thanks,
> shafi



--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/4hykACgkQrzg/fFk7axbIsACg5UEsET1bF8Z1RlHXuNY/jPqA
IAcAoI5XyRGf2aAsMoJZvsn8n3rSVcXK
=xcGf
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
