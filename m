Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:54940 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758199Ab2FVLK1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 07:10:27 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC] ath9k: raise aggregation limit to 64k for HT IBSS
Date: Fri, 22 Jun 2012 13:10:24 +0200
Message-ID: <20010825.m5IpWLuaVf@bentobox> (sfid-20120622_131031_021054_B6F55155)
In-Reply-To: <20120622105214.GC7934@vmraj-lnx.users.atheros.com>
References: <1340355904-861-1-git-send-email-sven@narfation.org> <20120622105214.GC7934@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1906625.lHI2Y6nIbH"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1906625.lHI2Y6nIbH
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 22 June 2012 16:22:16 Rajkumar Manoharan wrote:
> > +	/* update ampdu factor/density, they may have changed. This may happen
> > +	 * in HT IBSS when a beacon with HT-info is received after the station
> > +	 * has already been added.
> > +	 */
> > +	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
> > +		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
> > +				     sta->ht_cap.ampdu_factor);
> > +		density = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
> > +		an->mpdudensity = density;
> > +	}
> > +
> 
> No need to declare local variable. ins't it?

You want more than 80 chars per line or ugly/complex code...?

Kind regards,
	Sven
--nextPart1906625.lHI2Y6nIbH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJP5FKgAAoJEF2HCgfBJntGgSwP/iOecfEF2tVwd+SM0F0LBvMS
T1TIwT6hiZ02Nnc8lksglpqD95z23sOqpebFWiBFeruuCycBQLDwc49lb74hEFba
0q8S3Ahij5x92cNvhG/3eIug/4OcJy5pOBV2tLlbu6Ju98YIP71rxJ0KWdKvjhLq
H8tSfGnmVGhjYyvdEwrNOZD1V2SReC1tyFMLhuFSro3TrjcKX/DF8CzRF/WQYktY
VR/hTMZn8vPK7iI/1gckFHx03MN1Kj+tPsNrGKiXNcNeFAfJmfjU22WZumvSBJaf
XuCSdtZytxrFicmy9WMY/L3QjdIM4q51c3xlqU1n4Y5B2ODfj9oXj2XY6tfdHiM6
UJoLMaroAtQDJ0WgXe8lU/qiyJUmQPdUtQb6zqOWLU+ofQlYIdCPBx8yLIXiXhw9
8nlM42AvUtH7jxowKJIBI2qCRp0wgjDCHH7oSzhffx51GPeDs6YBIpO9hasSQLBF
u0Lv/Hzda9lijrSMFvfhF+pcgNICkZKc4Wv0gP8iALx6iEE1H3fEp25fr79+8rNW
G2z69pORX4IaYhs07hoMzQJR85jrdLqMC0uJR94zu4HowgJNhErflvFfKLePkKq9
tHTI4IEdvsKzFFpFLYTMxzcoMTBRNe05jYgQ4/iCVYx5aSE4rTifMEJ21L6qSmYi
sf9LuLSxcbQf/H4ff3Ga
=gRW0
-----END PGP SIGNATURE-----

--nextPart1906625.lHI2Y6nIbH--

