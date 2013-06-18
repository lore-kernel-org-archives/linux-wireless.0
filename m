Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:37329 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3FRPu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:50:57 -0400
Date: Tue, 18 Jun 2013 17:50:51 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv3 07/18] mac80211: add radiotap flag and handling for
 5/10 MHz
Message-ID: <20130618155051.GD27492@pandem0nium> (sfid-20130618_175106_074507_863B70C2)
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1368702045-27598-8-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371565626.8318.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
In-Reply-To: <1371565626.8318.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 04:27:06PM +0200, Johannes Berg wrote:
> On Thu, 2013-05-16 at 13:00 +0200, Simon Wunderlich wrote:
>=20
> > Wireshark
>=20
> doesn't really matter all that much, but I guess the radiotap standard
> also defines it.
>=20

Hmm, if this [1] is the official standard, then no, it is not defined. Don't
know when this was added in wireshark, and it was only added implicitly in
the code (no header files etc). But since it was there, I figured it would
be a good idea to re-use it (unaware that there was some "standard").

How shall we proceed, propose that on some radiotap mailing list officially?

>=20
> > +	RX_FLAG_10MHZ			=3D BIT(26),
> > +	RX_FLAG_5MHZ			=3D BIT(27),
>=20
> Does that make sense? We know what kind of channel we're on? Though it
> might be easier for the driver, so it may make sense I guess.

Yeah, it's a little easier for the driver, and I thought it would be
cleaner to get this reported through a flag.

Cheers,
	Simon

[1] http://www.radiotap.org/defined-fields/Channel

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHAgdsACgkQrzg/fFk7axa9dACfVP/e7DZv75Z1nsRVKvdk2PUo
2DIAoNfKxk3vllHThprGHx1OpQyCIOnt
=lrcB
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
