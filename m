Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYJJJO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 05:14:56 -0400
Subject: minstrel compiler warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wBjM2NSIW4E9BgCbKhZH"
Date: Thu, 09 Oct 2008 16:17:18 +0200
Message-Id: <1223561838.22490.79.camel@johannes.berg> (sfid-20081010_111500_871659_A51FD006)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wBjM2NSIW4E9BgCbKhZH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

on 64-bit:

net/mac80211/rc80211_minstrel_debugfs.c: In function =E2=80=98minstrel_stat=
s_open=E2=80=99:
net/mac80211/rc80211_minstrel_debugfs.c:98: warning: format =E2=80=98%8llu=
=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but argume=
nt 11 has type =E2=80=98u64=E2=80=99
net/mac80211/rc80211_minstrel_debugfs.c:98: warning: format =E2=80=98%8llu=
=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but argume=
nt 12 has type =E2=80=98u64=E2=80=99
net/mac80211/rc80211_minstrel_debugfs.c: At top level:
net/mac80211/rc80211_minstrel_debugfs.c:145: warning: initialization from i=
ncompatible pointer type

johannes

--=-wBjM2NSIW4E9BgCbKhZH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7hJqAAoJEKVg1VMiehFYih4P/idjFmoW6yvfPPq/7MhYWMOO
DZjOIvhylJlOpP+vjx5rHJpHM4T4O6FEjoWPe4HgNV/XRIiBznbxfEAamEVZusOq
Hh0yMWVkkvO/bASV3QfEJz3gIzAXOErKlzBCqiwGyn6EVjKDUUD9vdVTfCmCzmAb
xbCETqKOT8IXd+vx0VA2h+Ax56idl9T76n/iEFK3luKLReeq5TUXKX/QQzA6mXXj
q3jCixOjZPdgUAQNB6hDK4pgtJLZTrb8zSZ4h+Q86IhZYlTa+XaNAbbABjvQ8895
3wC4koHF+iH+H8wbW8Qqr4qcoiraDu5656+K6Q2lCV7RVFca9BCQK7mWb5JAhtgh
KKVrNiBF9c1E9zdHvipaeciPERUN2p4w5v84twqPSBUp/tNcFS1/xZ8Gr0jgPt+b
5xkRFxrSOtoXptuOBhNwtiFPbKWq8c4Xobz/o1+6DW0ACIIoLjOSkmRER7mUYqVD
PsIXz8qo5P0QstkWziZZqyQCqUwQsqSjwCyZvHKRjLtYJUTYaNVSCOp59dmQS+3C
Ryo1NMfvRbRoQHBiCujItQeqO9EgN//lUcXS65F2SN9ufAQGKPMVM1l/ocrK+kIe
RCJ8vlGybC2G+G8ocyr/FIxT2+mjpaVEZRl/PfZoKPoCGwBlKPM+dkA6bu9A/RkQ
HI8J+zk3gLc9psiBZbwd
=5ndJ
-----END PGP SIGNATURE-----

--=-wBjM2NSIW4E9BgCbKhZH--

