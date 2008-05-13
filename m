Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYEMXxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 19:53:13 -0400
Subject: Re: 4311 v2 Bail - 2.6.26-rc2
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1210722537.4279.43.camel@johannes.berg> (sfid-20080514_014950_992691_D85478C3)
References: <48294F0B.4040908@f-box.org>
	 <1210721604.4279.40.camel@johannes.berg>
	 <1210721764.4279.41.camel@johannes.berg>  <200805140146.06910.mb@bu3sch.de>
	 <1210722537.4279.43.camel@johannes.berg>
	 (sfid-20080514_014950_992691_D85478C3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dN3hZGaCNlvNCNhB119l"
Date: Wed, 14 May 2008 01:52:11 +0200
Message-Id: <1210722731.4279.45.camel@johannes.berg> (sfid-20080514_015315_789095_F345D752)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dN3hZGaCNlvNCNhB119l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-05-14 at 01:48 +0200, Johannes Berg wrote:
> > > b43-phy1 debug: Found PHY: Analog 4, Type 2, Revision 9
> > > b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
> > > b43-phy1 debug: DebugFS (CONFIG_DEBUG_FS) not enabled in kernel confi=
g
> > > phy1: Selected rate control algorithm 'pid'
> > > Broadcom 43xx driver loaded [ Features: P, Firmware-ID: FW13 ]
> > > firmware: requesting b43/ucode13.fw
> > > firmware: requesting b43/lp0initvals13.fw
>=20
> Huh? lp0initvals?!

Hmm. specs bug? But probably unrelated anyway since, well, it works for
other people.

We really need a raw monitor frame capture.

johannes

--=-dN3hZGaCNlvNCNhB119l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCopqqVg1VMiehFYAQJhhxAAhtN5tLA+f6XVhNbdxUHoD2bHAMtNL3z5
hC+76VD71o+pMeQWlz81VGWQf0MI5ubsmugFnSGMzR78e68rlK0mazlTCwnrb9Is
FHdnauEPhYqC/CRVPrt/vzzBdII6croSyptlMqr/On4iT+FuL+6noiOoIPRX1XE8
CMngbxyfPyhrMYnuxzAWYxZdrhhA872Br4hVPPoCOrwLo7A9pYuZkmybDuqaM7fq
mlcRmTlCPlDW0XiEUO6X1lquOJ2f+rKyG0OY0WrV+nUc3Pho5izotkKEVYrUhjIz
wdCM/5PssVE24I62iLRuI021Cuh59itdUyh6wgS0pW0ubF8S8M7HyITGMiXA8Cl2
J+ciShuf+0NTRgHhFyS3VEnVRQgF4gj7PKgdhl5Q8Cy6Fyk3OsOaNz/hD0DwgAzH
rPAnOEeZE3GKKZuIaPXddLdb+iLx0IvtOPpK5J1QkLsyb1Y1BKvQazi6JXppCg/j
FbTd34y4Jal6RlUdHxl33/Jbgs4V9LIXmv0W91IiuTk/H7lKFehjfM0Aexw6xDgj
SWSC2kz/H4s/o/wZCPys6sB+hE1j6hiZb2C3Qb1TFphrddya3RshE3OyfUF8QEeN
2t4K+x5d7yuYPF/sEeATNFp4KtyCXddD1I7c43sYQ4PH9BE+FQsKo6VWH50s/1Sj
jB4ZZdZ42So=
=G9+c
-----END PGP SIGNATURE-----

--=-dN3hZGaCNlvNCNhB119l--

