Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:50576 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab3FRPUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:20:08 -0400
Date: Tue, 18 Jun 2013 17:20:06 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCHv2 3/5] mac80211: add functions to duplicate a
 cfg80211_beacon
Message-ID: <20130618152006.GC27492@pandem0nium> (sfid-20130618_172024_590768_BC1C716D)
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371212124-26264-4-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371566972.8318.33.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
In-Reply-To: <1371566972.8318.33.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 04:49:32PM +0200, Johannes Berg wrote:
> On Fri, 2013-06-14 at 14:15 +0200, Simon Wunderlich wrote:
>=20
> > +static struct cfg80211_beacon_data *
> > +cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
> > +{
> > +	struct cfg80211_beacon_data *new_beacon;
> > +	new_beacon =3D kzalloc(sizeof(*new_beacon), GFP_KERNEL);
> > +	if (!beacon)
> > +		return NULL;
>=20
> Why not allocate one bigger block and use pointers into it? There's no
> (reasonable) way that it'd get really big ...

Yeah, can do that.

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHAeqYACgkQrzg/fFk7axaJpwCg5Ze6Q46iod5IVJn8iPtcw4+L
9uAAoNf2H58yNdS4tYUq5efIQISrDDEk
=4nwM
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
