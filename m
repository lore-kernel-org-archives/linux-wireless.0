Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2KSQjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:19 -0500
Message-ID: <1353343179.18299.27.camel@jlt4.sipsolutions.net> (sfid-20121119_174527_075537_17689445)
Subject: pull-request: mac80211 2012-11-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 17:39:39 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-TSzbtnd89+ZJNryKjYLA"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TSzbtnd89+ZJNryKjYLA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull my mac80211.git tree (see below) to get two more fixes for
3.7. Both fix regressions introduced *before* this cycle that weren't
noticed until now, one for IBSS not cleaning up properly and the other
to add back the "wireless" sysfs directory for Fedora's startup scripts.

Thanks,
johannes

The following changes since commit 43c771a1963ab461a2f194e3c97fded1d5fe262f=
:

  wireless: allow 40 MHz on world roaming channels 12/13 (2012-11-12 16:26:=
06 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 38c1a01cf10c6e4049b4ffbd4a6af655df2a46e1:

  wireless: add back sysfs directory (2012-11-16 21:37:52 +0100)

----------------------------------------------------------------
Johannes Berg (1):
      wireless: add back sysfs directory

Simon Wunderlich (1):
      mac80211: deinitialize ibss-internals after emptiness check

 net/core/net-sysfs.c | 20 ++++++++++++++++++++
 net/mac80211/ibss.c  |  8 ++++----
 2 files changed, 24 insertions(+), 4 deletions(-)


--=-TSzbtnd89+ZJNryKjYLA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQqmDLAAoJEDBSmw7B7bqrqZ0P/jFC+0ydNMO4u0wLBfuHiUoz
tQ8R8sl28cHhA4+MVQIz/DlhU9u9w8GGIBLMASYZPn4hFU9k1o4D/zm4+T0w9F/+
t6SeYrMAH+NdZyd6g68dhY9yrhuNDiNtoAsRGttOuvHbzvmSaIG/saxnbq3NrFfe
h/1BgBReSO37AAdYOqKEEAhk+6OSru1o4lkuWo2YNWA3alk+N87XBgsDlmCeNseY
JccZdGknrvX3e7tn1bGyIFEvTbqC4hsTiAfq4DB6X+L+5UGIIt1Jf3z41YAPWMKD
4cW5Kz5+BXAyXFt+npANe3ph46oQ4EXNogm79/c1Pw5Wkkbzkn6Vp0JtSGkGQ/Wq
eMFP5+33+ougZejwnqM+dJ/hDJQpLp0d/L2B810XcfCIzDK5izv9F+W8NcIQycET
qCW5lXFfoPfNGFlwDhZ7PH7jVK5vqXpQxOO82aDdSsCnMQVljPdBo7PyeHSY6JHz
Bs/SmcwrLqoZbh+3wLFT86ER1AZmk/DLYH3z63G2EYD7j+ygK3WQdbf7kBs8f+2a
tinkOEfEZX5XBr88xfxXaRBMMT7qiN2HV7/Gss5OjjflOUEd44Qy1bFPCaybJrbG
+7ErhN8ZsW7zLkolwchAtmQdYDD2TgV9+Wjc0LwUVZJ2dmq5eVw3KDjiUu3x/uoz
ixvMruVc5c/BdsBn6LSp
=5Wxf
-----END PGP SIGNATURE-----

--=-TSzbtnd89+ZJNryKjYLA--

