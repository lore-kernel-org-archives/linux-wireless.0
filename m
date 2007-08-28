Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXH1PAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 11:00:42 -0400
Subject: Re: mac80211 problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Jesse Shaver <J_shaver@comcast.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200708281025.50899.J_shaver@comcast.net>
References: <200708281025.50899.J_shaver@comcast.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bPXDJ4XppNsZQofpUOBX"
Date: Tue, 28 Aug 2007 17:02:03 +0200
Message-Id: <1188313323.7837.103.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bPXDJ4XppNsZQofpUOBX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 10:25 -0400, Jesse Shaver wrote:

> hayden:~/mac80211-9.0.4 # uname -a
> Linux hayden 2.6.18.8-0.5-default #1 SMP Fri Jun 22 12:17:53 UTC 2007 x86=
_64=20
               ^^^^^^^^^^^^^^^^^^^^

> net/mac80211/debugfs.c: In function =E2=80=98mac80211_open_file_generic=
=E2=80=99:
> net/mac80211/debugfs.c:28: error: =E2=80=98struct inode=E2=80=99 has no m=
ember=20
> named =E2=80=98i_private=E2=80=99


Yeah, well, duh. Don't use ancient kernels.

johannes

--=-bPXDJ4XppNsZQofpUOBX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1Djr/ETPhpq3jKURAn7KAKCik8T0b2UD7kUNm2FTKiEboFST5QCfSOuv
/SzPIQIH5L5+Cncp85bSm7U=
=It1q
-----END PGP SIGNATURE-----

--=-bPXDJ4XppNsZQofpUOBX--

