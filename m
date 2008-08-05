Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761175AbYHESMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 14:12:22 -0400
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Will Dyson <will.dyson@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200808052030.05748.IvDoorn@gmail.com> (sfid-20080805_200558_564592_4E1CC216)
References: <200808041636.41189.IvDoorn@gmail.com>
	 <8e6f94720808041821q760f8596g70a8ebc4c142989a@mail.gmail.com>
	 <4897B037.5040300@lwfinger.net>  <200808052030.05748.IvDoorn@gmail.com>
	 (sfid-20080805_200558_564592_4E1CC216)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0unRuCUnB1bKMXuN+tm/"
Date: Tue, 05 Aug 2008 20:11:23 +0200
Message-Id: <1217959883.3603.50.camel@johannes.berg> (sfid-20080805_201226_575301_BB72C5EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0unRuCUnB1bKMXuN+tm/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 20:30 +0200, Ivo van Doorn wrote:

> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [ INFO: possible recursive locking detected ]
> > > 2.6.27-rc1-rt2-wl #1
> > > ---------------------------------------------
> > > rt61pci/4405 is trying to acquire lock:
> > >  (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
> > > ieee80211_scan_completed+0x172/0x320 [mac80211]
> > >=20
> > > but task is already holding lock:
> > >  (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
> > > ieee80211_scan_completed+0x172/0x320 [mac80211]
> > >=20
> >=20
> > I get that same lockdep warning when using the mainline kernel with b43=
. It=20
> > doesn't seem to cause any problems.
>=20
> Sounds like a mac80211 bug then, can't find something obvious at first gl=
ance,
> but perhaps Johannes has an idea?

I ignore everything with the TX lock in it because those have been
wrongly annotated in a bunch of versions, including -rc1 afaik.

johannes

--=-0unRuCUnB1bKMXuN+tm/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImJfIAAoJEKVg1VMiehFYBVkP/2wyYeIrfYCPRiBVBshLVsfD
LiQuY2HaAjgW1P8kMhl5QOzDGvi0ihCIeINK9VOIPxSumH/X0igTs0UFTecGz0KM
QtxrxOVGXj+e/7uz+K928PxSLI+m1IzAsGhanxm1/yZHIZl4ffq76SJjByv8lGfs
XhEHR+sa9sHSCGJ1P5yDePGymp+toEFHbTcBeK6VHIsndGPEZ1ssy1Z7mw9uAO4+
8ueHsT5lL20R0kcDF5hAvGyzngVDMtcTAjg1g7b2wDuM5HRtwrVlxLrTYONqJA23
IgPLxaBrqU/nkbPN2vumivQWxy65Gqk53xaSG/+HHacSIAHbhIf3aRWg1HaZvCVQ
F9tSLZMOGnCX3kWjy6rJfg55lfORHFr1lcGLK7Ba7pNuhR0YJtE55S7pqJEzj0SN
GxFFp4mWjU2x/Eegd7rsEAz+ylWKT6qIEZTNzlC3Ica52sDbXpUcO15HE19YfwWf
yWuuRnh50dPDyZy1CkmRuop2SREFwhFXrlWjvMTafXIPZHNf8tN4oEqhths1KuIH
vshCnDv++q68Hn8J+zPVylJ5wtnuMF/5d+SSCt09mRMdsr6QTInRGaPGxO7tGqwU
OIP1rs2v0oWwWpf3CFN9mJGBvQ0jJrJeFZ3T5tZhGQ1iHzjAeZPgLfbLlwnLJbNx
ydTHTYS+/vFVPZelXCwU
=/RlY
-----END PGP SIGNATURE-----

--=-0unRuCUnB1bKMXuN+tm/--

