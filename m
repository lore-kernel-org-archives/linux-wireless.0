Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab3AINAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 08:00:18 -0500
Message-ID: <1357736439.9757.11.camel@jlt4.sipsolutions.net> (sfid-20130109_140031_290019_D985720D)
Subject: pull-request: mac80211-next 2013-01-09
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Jan 2013 14:00:39 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-FrtcB8xAUaWBVUshERps"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FrtcB8xAUaWBVUshERps
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

We found two bugs in the previous code, so I'm sending you a pull
request again this soon.

This contains two regulatory bug fixes, some of Thomas's hwsim beacon
timer work and a documentation fix from Bob.

johannes


The following changes since commit ba23d2068d85f6616ea5f92320c04e87d4b9e141=
:

  cfg80211: disallow more station changes (2013-01-03 13:01:45 +0100)

are available in the git repository at:

  git://git.sipsolutions.net/mac80211-next.git for-john

for you to fetch changes up to 2d31986764926630a6df72123a5e217219b32594:

  regulatory: fix restore_regulatory_settings (2013-01-09 12:19:52 +0100)

----------------------------------------------------------------
Bob Copeland (1):
      mac80211: fix mesh_hwmp kerneldoc

Johannes Berg (2):
      regulatory: fix uevent
      regulatory: fix restore_regulatory_settings

Thomas Pedersen (3):
      mac80211_hwsim: fix tsf adjustment
      mac80211_hwsim: hrtimer beacon
      mac80211_hwsim: fix beacon timing

 drivers/net/wireless/mac80211_hwsim.c | 90 +++++++++++++++++++++++++------=
----
 net/mac80211/mesh_hwmp.c              |  5 +-
 net/wireless/reg.c                    | 21 +++++---
 3 files changed, 83 insertions(+), 33 deletions(-)


--=-FrtcB8xAUaWBVUshERps
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQ7Wn3AAoJEDBSmw7B7bqrk4gQAKNTX3WBLuhnxRwXhUeLHWxl
5O4uivvduRxQ2zAKOT1dpe9Y/7/wfHEyx2GhRL7ZeYETlGMeBY3xgSE3CGQv/Jmh
cnncFMefO+Wv3dgVgwC0xVFQbBjXwABZ/1PEs6Qce+A4wn+QrpWlyJPVUU9wBHtU
TJs4RBglIUt8mhETubcxVJvQxdH89yYLLiaM2jlaHP7w+dxMLaj5/5II4Ykwvkol
knBAolAsjv9d24CS0byJbCnukvgpwbZOMEravyK9astt4nANRcvUnNBy5q7F+p2O
qse0XZIrXSDnvPL9J+a5vGQFD6fpJYTOdp0mBRS23qnXjYmgdr0kiVsF+mQ6ALXr
243/v4GEgzjfNoMSQ0vIcSJIFprt5CTH+TTKnUNSRlOMdklVOcUD3sU32+ojUQ9/
VoseCJ9dmz/TRPIWRTRQKl1fpy/8ZVTlXa9aPYeXA01rEQvNjgtXTUzP2DTB4eJD
ERmH14PuYfUJ/Fn1Ih6INHPHKCD9olQyfWIqpqFSfUu3vn/KtPOi1aw+TzBulBCn
O/q90S9ymxI667zZYrWheNsoI5AqVDgzSCMd+aretX4XFrLYLELlajcmJWEjnM95
Tm4vOD2KzfaZXRSc+3N23tYQ6vB3ik32wYvPqsYB4ytSSSEJHZqU+/q3wmCifjLR
ofluveVtGZ8+AA86tdSq
=vlbd
-----END PGP SIGNATURE-----

--=-FrtcB8xAUaWBVUshERps--

