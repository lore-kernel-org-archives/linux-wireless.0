Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbXJQMp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 08:45:26 -0400
Subject: Re: Problem with in-kernel iwl3945 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ismail =?ISO-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710171518.36393.ismail@pardus.org.tr>
References: <200710161317.45460.ismail@pardus.org.tr>
	 <200710161703.51343.ismail@pardus.org.tr>
	 <1192609081.8841.8.camel@johannes.berg>
	 <200710171518.36393.ismail@pardus.org.tr>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P9wKEq6DRBM/wtiC0U+6"
Date: Wed, 17 Oct 2007 14:46:05 +0200
Message-Id: <1192625165.8841.15.camel@johannes.berg> (sfid-20071017_134530_681618_10D808A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P9wKEq6DRBM/wtiC0U+6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-17 at 15:18 +0300, Ismail D=C3=B6nmez wrote:
> Wednesday 17 October 2007 Tarihinde 11:18:01 yazm=C4=B1=C5=9Ft=C4=B1:
> > On Tue, 2007-10-16 at 17:03 +0300, Ismail D=C3=B6nmez wrote:
> > > Replying to myself,
> > >
> > > Tuesday 16 October 2007 Tarihinde 13:17:45 yazm=C4=B1=C5=9Ft=C4=B1n=
=C4=B1z:
> > > [...]
> > >
> > > > wlan0     IEEE 802.11b  ESSID:"XXYYZZ"
> > >
> > >                          ^^^^^^^
> > > Looks like its in 802.11b mode instead of 802.11g.  That might be a c=
lue
> > > for slowdown.
> >
> > A fix was committed under the title "fix set_channel regression"
>=20
> This indeed fixes the slowdown, but can't associate unless I do a iwlist =
scan=20
> problem still persists :-/

I don't think that is related to mac80211 changes.

johannes

--=-P9wKEq6DRBM/wtiC0U+6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxYEC6Vg1VMiehFYAQLZeBAAua58H29Kw9abaJTKxih7YomY+dltlG+z
BH/gEMSHU7hbZG7CfNHPU5r5W3Gf8ZmT2SEyPkWm/R1IQHqasV2cqF8ON3178/rm
ziYJzlzFqT5ujVx49fNjLQa4hEykWmeJR2eslXHM1+UvvfpzbmEB2e4qntNTvmOn
lG5SCPXk/ZrnAK6zo0Fp8v/BssRWqC+mKAGgXFwBt5DdezppLqADPNyuiQPhkLfK
y1cQfGzkYSbj+xFXA1ydu0VFG3MazlofOCrDem7YymFMzzKPgB/J0oBCZ7MlF6AX
jCrbP5aNRUkAdaKAZjZS//CVbzGG3E9OVojOKBHNR40kUO149QGnl3gGg/0LmG/Y
WuFO8h4QZ/osWITSEk3/nVH6peFqhXnsIWwCHw2nzgGnDzPSuwenYqM8LYwe90s+
Bi8DN/U5DC9J5AAfmPwQKo/XziCSDP/a2LcLfXAUfgFVmV4smJyUF/BQCn6ckc1n
uAoZ10rzkfm0SFqCEknG+dBye4ZWOjmrnKy16ccDbE8fZqHvmyGVkF2h9V84lL+c
qMB/kESUHCUl2c5f2/1ya9GFiFMjlC7QEJMVSQODaqv+OGeYBjQvB0vOFWDuyuKK
Y89xB3TacYH+FAcqiR+EnZHz4ccpqdWaY5GCIbDf9oL55cT9obuWj8bb92i6577d
R/szkOy/LmM=
=u+7q
-----END PGP SIGNATURE-----

--=-P9wKEq6DRBM/wtiC0U+6--

