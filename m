Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYLWVq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 16:46:27 -0500
Subject: Re: [PATCH] mac80211: allow mode change if IBSS is not allowed
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <20081223210705.GA12572@tuxdriver.com>
References: <20081222213935.26129.4212.stgit@dv.roinet.com>
	 <1229982778.3775.0.camel@johannes>  <20081223210705.GA12572@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KyVDJlXgA/xtMMKaMOeT"
Date: Tue, 23 Dec 2008 22:46:30 +0100
Message-Id: <1230068790.31228.48.camel@johannes> (sfid-20081223_224630_424879_0200C9AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KyVDJlXgA/xtMMKaMOeT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-23 at 16:07 -0500, John W. Linville wrote:
> On Mon, Dec 22, 2008 at 10:52:58PM +0100, Johannes Berg wrote:
> > On Mon, 2008-12-22 at 16:39 -0500, Pavel Roskin wrote:
> > > Changing mode on an interface is not allowed if IBSS is disabled for =
the
> > > current channel.  That restriction should only apply when switching t=
o
> > > the ad-hoc mode, as it was prior to db17d8c4.
> > >=20
> > > Signed-off-by: Pavel Roskin <proski@gnu.org>
> >=20
> > Thanks Pavel.
> >=20
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Doesn't this need to account for the other beaconing modes?

Well, for now this fixes the regression I introduced, and how the other
modes should be handled we haven't really defined yet. But yeah, it
might make some sense for mesh too...

johannes

--=-KyVDJlXgA/xtMMKaMOeT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJUVwzAAoJEKVg1VMiehFYiZIP/A700pL/k5btpOnThNQbE4DU
Wvl6cfcpoly+5TaUMw4fKJEqHZHOOsEs4Dt69eW4yKuXendrcTip8igGT6kKLKKc
qq07GyIQWtAVXwA3WVpuAd8ovWdGivM5mQGZ8JpL1FyuABNM111dykpJwIwF2wYP
SB77RMqRTbClgzcsH6BaPPpoJf1nVjcW9O+8kVNPt6OLAjwru9w3lxSbrJ5ZplaT
wXe2oqF4MECvyRsrjuOIqfPO+GH0noCdEHbH93e/4/RdnH8EELaZytYzJkfU3R3h
2ltcfmhX7iLRLauU8guVrqPbNWwdNNdwRL/012YlOmrYP0efUFY6L7EX02AwmbvH
N+S3olFcHLbQbPrMpbSxIgrZ3J5dmkk8Gx+dIJ3uWjeomNIwFY0sWzASqfd40rYN
Ag6GQCVSB/Ov1H39JG6J3gRnAYL0GvAAhr9UbZgPuBJHDQfb2qGDPT+EOVLyBGY7
QdY+r4jmQw1SD6UuFEV4JTe3yrVhHATjDPZoUUF2Vl+65ddOWfWSu5ZGn4+HTTSd
/4CacXPU4b+k/Zm2/GHlxAaCwBOKLmu1wX8MkqzOerp7qdzSORzCJrRKpSBHiZ/4
g2J6Meu1BSFqWHTwRbAZ6Z15ZhdRT+p2yE5urhR7LCDX4hAA9sOoJ6TOLWRmEgsX
ryIshfctqa7YtSgteHr1
=jGj6
-----END PGP SIGNATURE-----

--=-KyVDJlXgA/xtMMKaMOeT--

