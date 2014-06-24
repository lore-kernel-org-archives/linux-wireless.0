Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49335 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbaFXQXl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 12:23:41 -0400
Message-ID: <1403627007.10831.13.camel@jlt4.sipsolutions.net> (sfid-20140624_182345_418484_1CCB4C38)
Subject: Re: pull-request: mac80211 2014-06-24
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 24 Jun 2014 18:23:27 +0200
In-Reply-To: <1403619592.10831.9.camel@jlt4.sipsolutions.net> (sfid-20140624_162019_776218_0A308EFD)
References: <1403619592.10831.9.camel@jlt4.sipsolutions.net>
	 (sfid-20140624_162019_776218_0A308EFD)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jQ0qQ663P6Fp/Cl1KfMP"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jQ0qQ663P6Fp/Cl1KfMP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-06-24 at 16:19 +0200, Johannes Berg wrote:
> Hi John,
>=20
> Due to travel etc. I've been a little slow this cycle, but we do have a
> few fixes that should go into the current rc series ...
>=20
> We have a fix from Eliad for a time calculation, a fix from Max for
> head/tailroom when sending authentication packets, a revert that Felix
> requested since the patch in question broke regulatory and a fix from
> myself for an issue with a new command that we advertised in the wrong
> place.
>=20
> Let me know if there are any issues.

Well this was pretty stupid ... here's the actual pull request.

johannes


The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f=
:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD

for you to fetch changes up to 02df00eb0019e7d15a1fcddebe4d020226c1ccda:

  nl80211: move set_qos_map command into split state (2014-06-24 16:13:10 +=
0200)

----------------------------------------------------------------
Eliad Peller (1):
      cfg80211: fix elapsed_jiffies calculation

Johannes Berg (2):
      Revert "cfg80211: Use 5MHz bandwidth by default when checking usable =
channels"
      nl80211: move set_qos_map command into split state

Max Stepanov (1):
      mac80211: WEP extra head/tail room in ieee80211_send_auth

 net/mac80211/util.c    |  5 +++--
 net/wireless/core.h    |  2 +-
 net/wireless/nl80211.c | 11 +++++------
 net/wireless/reg.c     | 22 +++++++---------------
 4 files changed, 16 insertions(+), 24 deletions(-)


--=-jQ0qQ663P6Fp/Cl1KfMP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTqaX/AAoJEDBSmw7B7bqrOsoQAK5DyeVrmoSzdE+TBinhXjV2
xUhn00xBsJH1gJAEhGqAx4gHdGnKP0jHjcIEUv2J7HMFUAT8dTIQubvMcN9S0bvS
A+5lg/MDKvPp8QR5QIkex/GXyL1ZGnaDxugo3McjQAr3IM5+Euep9xBsFS6/2cX+
De+iEfCQVs/9/Su03tORhnfrcCExVpnVH95cg60y8z6qtWyEJvyrr0WJYXv9LgzY
iVA4Vf55U4bucN3LpniAn9mn9ZMQYPtgmarTOJw37GOe7vtdJdGn7ByvjSU7Q2iq
4rWkI8cP1koSIGpKyzxsQrEg0JpBZ/em1hyOTDHkvH3qSQlEOI85i1EIB6fTRZ5g
YE/PwKC/LHNR4LsZSdxfn30Ta1zQMC7A0LhZZDW4clnsZVzOM2J2QgAvDuigObtQ
xhGpgBuw6P23VQkLl/mTtZ90rcvfTrxV+JGpG+cu6acLlFwEzeGNVgfl1lI7DC9L
yOTQi3zz1lhQtW4HPGTQddAwAXMe2Mrv4At/yPWs3s98SFB2MLFZiio7JqGLBsUV
R6WEsmad+JtJBRwxYVqih7KiR7RnK3lAaq6JtqE5GNkyOXXyaKbBgqgBEg4+L5WD
KZf+PSGrrddhajjkQVWxqQIpRG1Ndw7hb1VEXs4ia7ZdOBlL0/m86/MYbJ+YCjDB
ZIWfTWhBMy5Iqn4ncO9R
=8T+0
-----END PGP SIGNATURE-----

--=-jQ0qQ663P6Fp/Cl1KfMP--

