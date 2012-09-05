Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:20891 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2IEGfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 02:35:16 -0400
Date: Wed, 5 Sep 2012 08:34:58 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg/nl/mac80211: use per-band basic rates bitmap in IBSS
Message-ID: <20120905063458.GA6029@ritirata.org> (sfid-20120905_083520_440902_147CC128)
References: <1346784741-7003-1-git-send-email-ordex@autistici.org>
 <1346787524.3737.43.camel@jlt4.sipsolutions.net>
 <20120904194532.GJ22841@ritirata.org>
 <1346788056.3737.44.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
In-Reply-To: <1346788056.3737.44.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 04, 2012 at 09:47:36PM +0200, Johannes Berg wrote:
> On Tue, 2012-09-04 at 21:45 +0200, Antonio Quartulli wrote:
>=20
> > > As far as I understand it, the basic rates that are passed into the
> > > kernel are intended to be used when the kernel creates a new IBSS. Th=
is
> > > always happens on the channel that is also passed in, so it's always
> > > bound to a given channel (band).
> >=20
> > I think basic rates are also used in case of merging, right? In this ca=
se we
> > could switch to another channel (and band).
>=20
> No, as I understand it we should in that case use the IBSS's existing
> basic rates, not our own.

mh..ok. At this point it doesn't make sense to really store all the bitmask=
s.
Will modify it.


Thank you

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBG8pIACgkQpGgxIkP9cwf6WgCfbgoXgBIBeXIZ36Jezg9jJzxz
ctEAnAr/urItsJKmE+HMj8sVwjTmL1vE
=/V9y
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
