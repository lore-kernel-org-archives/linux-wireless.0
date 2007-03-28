Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbXC2LHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:07:16 -0400
Subject: Re: [patch 4/5] IEEE 802.11n management action frame data   structures
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mohamed <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20070326164503.f276cd71.randy.dunlap@oracle.com>
References: <1174909342.1364.60.camel@dell-4965.jf.intel.com>
	 <20070326164503.f276cd71.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7JweSLo5aQbRs0I5vVT8"
Date: Wed, 28 Mar 2007 21:12:10 +0200
Message-Id: <1175109131.5151.92.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7JweSLo5aQbRs0I5vVT8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 16:45 -0700, Randy Dunlap wrote:

> > +struct ieee802_11_addba_param {
> > +	 __le16 reserved:1;
> > +	 __le16 backPolicy:1;
> > +	 __le16 tid:4;
> > +	 __le16 bufSize:10;
> > +} __attribute__ ((packed));
> > +
> > +struct ieee80211_delba_param {
> > +	 __le16 reserved:11;
> > +	 __le16 intiator:1;
> > +	 __le16 tid:4;
> > +}__attribute__ ((packed));
>=20
> These bitfields are all local to one machine, not transported
> across a network to systems where the bitfields may be represented
> differently?

You wish. No, these bitfields need to die, this is actually part of the
"wire" format.

johannes

--=-7JweSLo5aQbRs0I5vVT8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCr4K/ETPhpq3jKURAmEfAJ9eew83sAjlnkC2TtzCFwefUVUH3QCgi4rK
Fr0a03nsRHuIYKeJSC3s7ho=
=+WLA
-----END PGP SIGNATURE-----

--=-7JweSLo5aQbRs0I5vVT8--

