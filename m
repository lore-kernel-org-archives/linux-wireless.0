Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZFIOuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 10:50:01 -0400
Subject: Re: [PATCH] mac80211: don't use master netdev name
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244558869.895.7.camel@mj>
References: <1244557112.4672.20.camel@johannes.local>
	 <1244558869.895.7.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YsUwbOYDh2/wZ7WICpRd"
Date: Tue, 09 Jun 2009 16:49:30 +0200
Message-Id: <1244558970.4672.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YsUwbOYDh2/wZ7WICpRd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-09 at 10:47 -0400, Pavel Roskin wrote:
> On Tue, 2009-06-09 at 16:18 +0200, Johannes Berg wrote:
> > Always use the wiphy name instead.
>=20
> No objections against the patch.
>=20
> Maybe we could use wiphy names for the network devices?  That is,
> wmaster0 would become phy0 and so on.  Using two names for the same
> thing is confusing.  What's better is that we won't have wmaster0
> corresponding to phy1 after the driver is reloaded.  We'll have "phy1"
> in both namespaces.
>=20
> I wish we could hide those master devices using some "hidden network
> device" attribute, but it's not happening.

Actually, the reason I'm posting this patch is that I'm killing the
mdev.

johannes

--=-YsUwbOYDh2/wZ7WICpRd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLnZ3AAoJEODzc/N7+Qma++sP/RSYjknxAfNxYMmN6dy6lTlO
Mm9OGxvqRigNP/+yq4InxokZkICr/HYV2hRT2MC6c6tlRqeOqT5VDr/x4u/PDZdJ
oG/kdUUP6j+dSNo5HHsOyzLsgm1IdwJ+qZFDPbf0y3kfq4CGLxz9tTTyTwb21G/B
Xrd4VoEIVq6aC5xuaXBpGWBM4QEDVvoi54wK+uCSXZ9divqU2e2YBIhIS+QULYT5
44RMfdHsJMGFyf+Kpd9MvyH+1ZnQY4LPhIfdI/gK17Uo37E+zbjN5xn7u0ufZoqZ
UXeMibgk+S1zgwtc9p9FOYuT5BAEHFUZtXPR2C8mcPzexnPzf6ul8XLNODyuD77S
mhblGs+4hNrnh0amN61PMHOM3NIBlst40T7QEcoqyildCbW8FE3X06NMJYwXa/N7
2A3gyZK+xhzkVTcgIG9aYzOB0PmHxcO1mfnqm8P1ccycCSBVmS5XrNxbQrZXMAPY
yU6WyOjfKyx0uDj/vvJNr8Cs4bnDkMrOK1N91FGVlpXJzrrFvxcv044br6hfDXR3
TBu9gzTY/E1UrWG3QhI4HtrFvhXK5N/PyPia25KzE5ERUN6NZAO0cWo/QUxvbzhG
8KwGl4dAj5DBr0GiU6WvFEH/WEE0LLZUsTZj7h1yNz7LFOk9qfxITf8MNSxUU00P
AhvvPwtebGGrms6aqsYe
=1Y6T
-----END PGP SIGNATURE-----

--=-YsUwbOYDh2/wZ7WICpRd--

