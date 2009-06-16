Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758035AbZFPS5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:57:21 -0400
Subject: Re: [PATCH] cfg80211: allow adding/deleting stations on mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <45e8e6c40906161155i1e5dc5bag114dea7a8c6caa66@mail.gmail.com>
References: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
	 <1245177307.21287.34.camel@johannes.local>
	 <45e8e6c40906161142m759e6ecdgc6765333a4cced01@mail.gmail.com>
	 <1245177946.21287.42.camel@johannes.local>
	 <45e8e6c40906161155i1e5dc5bag114dea7a8c6caa66@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fEtC82lV3obby0+Jw05k"
Date: Tue, 16 Jun 2009 20:56:53 +0200
Message-Id: <1245178613.21287.45.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fEtC82lV3obby0+Jw05k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-16 at 11:55 -0700, Andrey Yurovsky wrote:

> > Ok, fair enough. There are a lot of quirks in the mesh API, one of thes=
e
> > days I'd like to make it less like wext and have you join/leave like th=
e
> > ibss commands instead of setting each parameter one by one...
>=20
> Thanks.  We'd like to hear about any quirks/issues as we have some
> bandwidth to work on mesh again and we would like to address the
> configuration/API issues.

Well mostly it's the thing with configuration parameters affecting the
interface "on the fly". But I'm not familiar enough with all of the
parameters to actually know which ones _can_ change on the fly, and
which ones change and thereby make you part of a different mesh.

johannes

--=-fEtC82lV3obby0+Jw05k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKN+ryAAoJEODzc/N7+QmaqfsP/0fi96leiBRJh0PPRKWpPwwX
bgcF1Ar0vN3d3h9XHvJinTomhkSpxxZAOEktIQTMeQnrA0Wpa9qd0iJ6J1t8dKdW
K0iX0vot8I0nl8hgnwffP2kfRJNJCq8Mcr+rizMTwc3DRC3jYbwvQb4w2KCpyXjb
olGYcTJmVRGv0NuA6H0yEFu/KgGSZcqOMutDDErhImU4F4PCgLuFKINxahg2Ni4L
08D9fJ8WLkT23uVlDZJBaPgkY9JoGldVVI9L2XwyAQwx7YQ2kOoCiDzXeX/Swwka
ZIXa7nExSAgt/QgJh9NigbOqcXYVIJJFNW9xrChs/znmwBiqqxREYnmugd8wYX/+
cYatjGQvsFkakY2WSalNnG2oidOxpkchJBSw8jk3D445abX4o5qZbNQvjCI6NYi/
XnzvJw7N+1VpBtMlTRTCOny6LRS5WAwmY2xR+8l6aRLrq9lV+GZweutMEmUK7DaT
84YSeg1ywtxS/F8OntVhW0mQTX7rZ+aw0wNERDpZTPmJsyaNBWY15uc9Tz7S8zaZ
g6g7rwtaDhHZMjzeAUm03eAJCh69GH21Zq2yxTUeRcK6VtglTJo7KLuxCWlDr5mL
LBAW9BPIJFF0mFPkxAxFwYRKp49eBpcHMPfIV7GK6qJI4+3av8s5RctOHZ58v+IM
6aYTEZ6+Rp/Z64qH15n0
=WYOC
-----END PGP SIGNATURE-----

--=-fEtC82lV3obby0+Jw05k--

