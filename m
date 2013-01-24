Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55404 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3AXQeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 11:34:17 -0500
Message-ID: <1359045275.21908.7.camel@jlt4.sipsolutions.net> (sfid-20130124_173421_531453_723C11B9)
Subject: pull-request: mac80211 2013-01-24
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 24 Jan 2013 17:34:35 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-F/Gmt58c/kxZJsDKHAxM"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F/Gmt58c/kxZJsDKHAxM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

One fix from Dan for a possible memory overrun.

Please pull.

Thanks,
johannes


The following changes since commit 8680451f38a64bd270233b3c0eeb7c45f2b5efe3=
:

  mac80211: add encrypt headroom to PERR frames (2013-01-16 23:24:51 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to c49dc9008b1c641a86837297df7c90cef070571b:

  cfg80211: off by one in ieee80211_bss() (2013-01-24 15:47:22 +0100)

----------------------------------------------------------------
Dan Carpenter (1):
      cfg80211: off by one in ieee80211_bss()

 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


--=-F/Gmt58c/kxZJsDKHAxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRAWKbAAoJEDBSmw7B7bqrYH0P/jlTnhax98x/kTk+Nh1Q7vWt
Ba4mAvLL4iGvoraonTAworXlGutQND43ojlI0ceFCtnB33ucZlqE2gaYxAQ9zm9m
6+xEsZ2ACTX+HaWR7ysStp3u4ZiV6m/M/vzyTykCZ8eNeylT05vPdVcoKVpnG2nk
qflsr5B1x49+r4V2XicD70JTyo+9IRb4NZazEmudBgneT1aQZgQeZPFwZA0El7JY
j8jtL7+KJio9K4u4A6flDKkpjNd0o6BkixKi1UisIoXrga2FhlwQLmtU2atl5TiT
0Rzro3i2x4vuxBcqP+HIJnGMXeaMTV/JC9w8PX6xAMFIrMPUwFE2tjCHt27RoDVo
RN1cJNgsQOWgJQw4EBzEMSkLEjEEFlVb7qUqVOgLiQERHiIBoFNuoarEyfO1n89A
pxRXEotTI2qGDgTD3v9ENnE6WFMECxNncMVp1hJt+gKVaPN/HVnEXrtX8Grg4dTP
OzET7kdMx8GMcGR2MkG8508sh/opJaLVUqTVMbdREW0fLgChTRUSndCCsxlUfEnN
S4nvYFaVTMCLozQwbFT48fUTAwWaTR3Falw0CbrQegHvn9aeOF1nBfhiQWKoAzcZ
RyJzWscXQ4x5qeNGnh41Bv0Dec+eUPL+UDfiJC1+aCAf4YAv9ZE36OM5A4RkcMkO
TRdF9NCT0cYAn9/qZdOe
=pd0N
-----END PGP SIGNATURE-----

--=-F/Gmt58c/kxZJsDKHAxM--

