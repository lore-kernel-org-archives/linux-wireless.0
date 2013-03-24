Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3CXKVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 06:21:34 -0400
Message-ID: <1364120480.9224.0.camel@jlt4.sipsolutions.net> (sfid-20130324_112146_840826_7554F1ED)
Subject: Re: pull-request: mac80211 2013-03-22
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 24 Mar 2013 11:21:20 +0100
In-Reply-To: <1363947571.8238.4.camel@jlt4.sipsolutions.net> (sfid-20130322_111945_083051_806A9563)
References: <1363723052.8336.6.camel@jlt4.sipsolutions.net>
	 (sfid-20130319_205755_751711_D4ADDEEC) <1363947571.8238.4.camel@jlt4.sipsolutions.net>
	 (sfid-20130322_111945_083051_806A9563)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-nxLjgcP6QXAdnIpRfmHW"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nxLjgcP6QXAdnIpRfmHW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

*sigh*


Testing found another issue. I'm not going to resend this, just give you
a new commit ID.

> I have two tracing fixes (one from Vladimir), two fixes for P2P device
> crashes, a fix for a BSS memory leak/lost update problem and a fix from
> Ben for a scanning issue in mac80211. It's a little on the large side
> because one of the P2P device problems required a bit much locking work,
> but I've run through all the different scenarios (wext/nl80211,
> p2p-device/station interface, ifdown/rfkill) to verify locking with
> lockdep.



> The following changes since commit 801d929ca7d935ee199fd61d8ef914f51e8922=
70:
>=20
>   mac80211: another fix for idle handling in monitor mode (2013-03-02 21:=
24:42 +0100)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-jo=
hn
>=20
> for you to fetch changes up to 9e68a67a888d98bda8393c29dde12fb4f0b42a19:

Really 370bd005937c0e00f9104a602f9fe1dd6b21b54b now.

johannes


>   mac80211: Don't restart sta-timer if not associated. (2013-03-22 10:55:=
55 +0100)
>=20
> ----------------------------------------------------------------
> Ben Greear (1):
>       mac80211: Don't restart sta-timer if not associated.
>=20
> Johannes Berg (6):
>       mac80211: always synchronize_net() during station removal
>       cfg80211: fix potential BSS memory leak and update
>       mac80211: fix crash with P2P Device returning action frames
>       cfg80211: fix wdev tracing crash
>       mac80211: fix virtual monitor interface locking
>       cfg80211: always check for scan end on P2P device
>=20
> Vladimir Kondratiev (1):
>       cfg80211: fix inconsistency in trace for rdev_set_mac_acl
>=20
>  net/mac80211/iface.c    | 35 ++++++++++++++++--------------
>  net/mac80211/mesh.c     |  3 ++-
>  net/mac80211/mlme.c     |  6 ++++--
>  net/mac80211/rx.c       | 14 +++++++++++-
>  net/mac80211/sta_info.c | 12 +++++++++--
>  net/wireless/core.c     | 57 ++++++++++++++++++++++++++++++++++++-------=
------
>  net/wireless/core.h     |  3 +++
>  net/wireless/nl80211.c  | 52 ++++++++++++++++++++++---------------------=
-
>  net/wireless/scan.c     | 24 ++++++++++++++-------
>  net/wireless/sme.c      |  6 ++++--
>  net/wireless/trace.h    |  5 +++--
>  net/wireless/wext-sme.c |  6 ++++++
>  12 files changed, 149 insertions(+), 74 deletions(-)
>=20


--=-nxLjgcP6QXAdnIpRfmHW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRTtOgAAoJEDBSmw7B7bqrheoP/2AJz5QZXxRyw19TY4C+H3mN
A9n/LZA45ManvsknDR0ySVTkdcuj28XjFicIhBh0vdIT1hEwKNqt8c0Xoud7s9Zc
fow0RwgT/3uJ8Y6bmfqFfc+Ftr5/sjo1RGw8TNj5HEAtod6SAf3BMJARuGLvzpP4
zf5epdBnmDW3r+eeYKJEg1HUhWSepomAarlnabTvgWkXBfgJMBwcykxuqd49rYnC
w16x7287GBPAJKIOqXY38kUejxbEjBH0Ush4O4mVbr7xD0accXULlMcZOnQWrBjK
R8kXytelAloGbQjauqFtlyzrN9+4rw7jh7SUoSXiugOS57OU7Hj5PsZ4E2yW2vJw
scFdcA+/jvEfiur64Ym1la2e7TpQgo6uCAs10aAyglLIVnvki4LkpmiZ6Gb3jLNi
3oaPzFQgIyvTzSaYrCux5z6pzYguR/685UkVlfK4yEbI0hCXDvPhkWQSLJ+mfUQZ
vICtka+q41kGTlzcRhj2LU5F/40qgF+u4yPb5m1SLY9JIwB6n/BwKTBUKIfFl+wM
dcsOh2quUnx1PZUfykMGdfg2VLXPxPSFDKSGnfqfhx2nfZS5Th7KkaYFNge2rA7f
vkM5lOzT/r7QQlnM3fQSik3CAaZhreSjBVnQRRVGzCEWM+vrsqd6swS0uBjweu+p
PzniwMrQDsi0PXa7NU4t
=f2dX
-----END PGP SIGNATURE-----

--=-nxLjgcP6QXAdnIpRfmHW--

