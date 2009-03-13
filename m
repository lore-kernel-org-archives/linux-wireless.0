Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZCMKtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:49:33 -0400
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <1236941058.5235.12.camel@johannes.local> (sfid-20090313_114453_238290_13C307AD)
References: <1236939917.5235.7.camel@johannes.local>
	 (sfid-20090313_112555_620577_8A85228F)  <1236941058.5235.12.camel@johannes.local>
	 (sfid-20090313_114453_238290_13C307AD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HXg8PLCNUXkWTAKoMjst"
Date: Fri, 13 Mar 2009 11:48:59 +0100
Message-Id: <1236941339.5235.14.camel@johannes.local> (sfid-20090313_114936_050438_5FF0B5AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HXg8PLCNUXkWTAKoMjst
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-13 at 11:44 +0100, Johannes Berg wrote:
> When mac80211 resumes, it currently doesn't reconfigure the interfaces
> entirely and also doesn't reconfigure BSS information -- fix this.
>=20
> Also, to be able to test this, add a debugfs file that just calls
> the suspend/resume code to see what happens when we go through that,
> without needing the time-consuming suspend/resume cycle.
>=20
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> v2: rebased on top of "stop queues across suspend/resume"
>=20
> zd1211rw currently doesn't survive this properly, I'm not sure why,
> but it keeps saying
> 	zd1211rw 1-1:1.0: error ioread32(CR_REG1): -11
>=20
> Please test with other hardware, we need to figure out whether or
> not something is missing in mac80211.

ath9k survives ping -f without even blinking.

johannes

--=-HXg8PLCNUXkWTAKoMjst
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJujoZAAoJEKVg1VMiehFY7xwP/RFTUdruej1qd5hrlAV3KXGc
R7eJwzyA1w+c5avW+LD6BdWDfJ9wU+Rthc1mGfa3SUXDb+WEmysJLLVxGlLWq0Ij
cCWmY3NSvv+5nqK2Ujj1bem1MWj5wNaDJEuTkonHqueDjVccUwxpLzfEFduGkSF2
ue5VSGcgU/RcxCWISiN+wxns1KCAD6mX5IcBm2YwepQEBld/L+SPsVdxuMfLznN7
fVO65RhrwZHTbj9I1dnW2CxqcWuU/5cJYFh44X9e1JUsShNbDoKshANArdvOhs/G
SVagiliU/JGOHMwkKWz7OT1xdtcQ9xy1qVsHeRlj+z+sM1ejCkYD5BKPPQZv4G+g
XPCivuDi18VIGDBs7pdKw1CFT2JkqKu5826yOCzr4gSCX6A2qoTdH8Cnq3P61IPb
SWa1PGhmdit/ypBCBhHuvnKvE6qIJXjqj2S9mnS4m6hpCZSQYupr4yKakU2IYa/E
6xgRgROYyX5aX+yZlPRRsz3vk8y4gIg/aPqda7i38xsFgOe79YgOKyThZzZ59xRt
f661Xyby/TALvcYWmnklHATM9qryQZ8zbg3nHca50f+iG8I/XBkx3GjOxHJeZ6k5
d6+EXATMfc7TwEwlevBsbBjtIlepHkpMfOYny32rJf3e0aU8JnkaMrNY+Xe0Ams6
C0mk4xgqHcWmP5wr47o+
=79xS
-----END PGP SIGNATURE-----

--=-HXg8PLCNUXkWTAKoMjst--

