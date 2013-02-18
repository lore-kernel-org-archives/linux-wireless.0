Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab3BRTgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:36:50 -0500
Message-ID: <1361216202.8555.49.camel@jlt4.sipsolutions.net> (sfid-20130218_203653_583574_D82616B2)
Subject: pull-request: mac80211-next 2013-02-18
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 18 Feb 2013 20:36:42 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-OzXik0mu6JL8sr3atoWL"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OzXik0mu6JL8sr3atoWL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Like iwlwifi-next, this would almost be suitable for rc1.

I have a fix for station management on non-TDLS drivers, a CAB queue
crash fix for mesh, a fix for an annoying (but harmless) warning, a
tracing fix and a documentation fix. Other than that, only a few mesh
cleanups.

Please pull.

Thanks,
johannes

The following changes since commit 93c78c5debeb9c7101ecc73347d4730c26a98c05=
:

  mac80211_hwsim: ask mac80211 to reserve space for chanctx.drv_priv (2013-=
02-15 09:41:45 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 8c6d59ee3509acd474365c34db291b950d2e66bf:

  cfg80211: fix station change if TDLS isn't supported (2013-02-18 18:26:24=
 +0100)

----------------------------------------------------------------
Bob Copeland (1):
      mac80211: enable vif.cab_queue for mesh

Johannes Berg (4):
      mac80211: clean up mesh code
      cfg80211: add correct docbook entries
      mac80211: fix harmless station flush warning
      cfg80211: fix station change if TDLS isn't supported

Seth Forshee (1):
      mac80211: Fix incorrect use of STA_PR_FMT in trace points

Thomas Pedersen (3):
      mac80211: clean up mesh HT operation
      mac80211: stringify mesh peering events
      mac80211: don't spam mesh probe response messages

 Documentation/DocBook/80211.tmpl |   4 +-
 net/mac80211/cfg.c               |  14 ++--
 net/mac80211/iface.c             |   8 ++-
 net/mac80211/main.c              |   3 +-
 net/mac80211/mesh.c              | 116 +++++++++++++++++----------------
 net/mac80211/mesh.h              | 105 +++++++++++++++---------------
 net/mac80211/mesh_hwmp.c         |  68 ++++++++++----------
 net/mac80211/mesh_pathtbl.c      |  89 +++++++++++++-------------
 net/mac80211/mesh_plink.c        | 134 +++++++++++++++++++----------------=
----
 net/mac80211/mesh_sync.c         |  47 +++++---------
 net/mac80211/rx.c                |  12 ++--
 net/mac80211/sta_info.h          |   2 -
 net/mac80211/trace.h             |   6 +-
 net/mac80211/tx.c                |  26 ++++----
 net/wireless/nl80211.c           |   9 ---
 15 files changed, 309 insertions(+), 334 deletions(-)


--=-OzXik0mu6JL8sr3atoWL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRIoLKAAoJEDBSmw7B7bqryNkQAIB6U1C89wT6UAdNb+7blYKY
BhSqYOvN6yWNnzmhoGOp9sB/pjR33hbuA2SMDL5x4rnqSV7Ml8muxP8jyIF1dd+z
H4oEILAYunSVcZumC7Htyt+ZTAgBtTgiGh2UDFCGSW3j2eGIGL9+Qgq8jh9zwS0J
XsbG1sHtClFPimkDNAEN4WD6fIVPdAQekbuxPXRtixMlwyS/EsaojokSDSVFSMKV
lpzkHdJDsElHZCO2lLf70hiOf0M9nmDJSCAPlE9tbkUnrMd/RUtRvi/InBXPw+gP
Gm4SBA7SQPLQprbpA+vBSGqW0lu38GojxMyMT8TWsaUTnrAJIkwF344CH9ivUqVW
sDE4zTj7MxENAjS0bVGVMS+pdU+nDnuikKIHmDHXiYp6PAv/zD4ypzl4CkRnTWRd
PM2K4YYydMYMq/VwSPqK6OeBb95OlwqX4sC9rr1edmmlyyN2XVRb8wHEFhC+R+L/
3R14xEpCjPlSw7NzyqWRXQI7NUxGg3mNMsSkk4FO/0FmyWnDt3vkBgBjnyYM/NFy
IpceuXqxtFEz/hlOKp8Xrus8Y9x1OehYs2EiNK+RE0rH0D5ywRrnz/mw/8FvZY8j
IE0T14HjzCD9dmwvX/K9UVg56XJD6pc8LuP1fopoSWmuoQVTiXjF1YCXtnSAzoo9
UaL61mj3ilM1L7nCPF44
=cXD1
-----END PGP SIGNATURE-----

--=-OzXik0mu6JL8sr3atoWL--

