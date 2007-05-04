Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767830AbXEDLGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 07:06:14 -0400
Subject: Re: [PATCH V3] mac80211: Add support for SIOCGIWRATE ioctl to   provide rate information
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070504130019.2f0911ca@griffin.suse.cz>
References: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net>
	 <1178276312.7408.9.camel@johannes.berg>
	 <20070504130019.2f0911ca@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5z/aPywKdJTAENWtsPEp"
Date: Fri, 04 May 2007 13:07:13 +0200
Message-Id: <1178276834.7408.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5z/aPywKdJTAENWtsPEp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-04 at 13:00 +0200, Jiri Benc wrote:
> On Fri, 04 May 2007 12:58:32 +0200, Johannes Berg wrote:
> > Is this racy if somebody changes the type of the interface at the same
> > time? Would a fix be to sta_info_get() beforehand? I really don't know
> > without digging the code, Jiri, Michael?
>=20
> It's under rtnl, so that's fine.

Hah, good point, sorry.

johannes

--=-5z/aPywKdJTAENWtsPEp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGOxPh/ETPhpq3jKURAsvPAJ9GWiNj/ys185sfEiK+4wkzAiIFMQCeO8xU
5xO0TuadvoY8jFiSk1HE0tQ=
=4FfD
-----END PGP SIGNATURE-----

--=-5z/aPywKdJTAENWtsPEp--

