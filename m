Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYJKNqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 09:46:24 -0400
Subject: Re: [PATCH] mac80211: make retry limits part of hw config
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200810111540.06457.IvDoorn@gmail.com> (sfid-20081011_154014_330805_612C4CDD)
References: <1223682835.29811.10.camel@johannes.berg>
	 <200810111540.06457.IvDoorn@gmail.com>
	 (sfid-20081011_154014_330805_612C4CDD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zHs/FF7FOBJ5bjoSJVtS"
Date: Sat, 11 Oct 2008 15:46:18 +0200
Message-Id: <1223732778.29811.41.camel@johannes.berg> (sfid-20081011_154628_267808_F047C598)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zHs/FF7FOBJ5bjoSJVtS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-11 at 15:40 +0200, Ivo van Doorn wrote:
> On Saturday 11 October 2008, Johannes Berg wrote:
> > Instead of having a separate callback, use the HW config callback
> > with a new flag to change retry limits.
> >=20
> > Not the cleanest of all patches in the driver area, but it should
> > not change anything wrt. how they work.
>=20
> For rt2x00 it looks good, the entire config handling in rt2x00 will
> be changed anyway because of your patch=20
> 	mac80211: introduce hw config change flags
> Because that one really makes things easier. :)

Yeah I figured you'd say that :)

johannes

--=-zHs/FF7FOBJ5bjoSJVtS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI8K4mAAoJEKVg1VMiehFYelUP/RbxUCFFnjOSVJZTbq6OCQjg
pFPhXqJRpXBKt91lvh7bkhfu1ql7SbOLYb7zk+P1IXEIO48hdTnoJF29Bu7LpfzJ
+e93Wk3my322aiEaiQO7ttW1s2KzsbFHrAFO21LjWclZ3WX3iYak0LNwq0WjbFgO
lSIUhXrp6LgNSxAFhAtb6V9/lDOq9Lf7RFt44eOOn4IdPmjg5Z/a+rue8rC2nG5K
/ZCybDwI3R6QAbF13BIGKsoyDiL/Q1NK2RJfRG/zU3tUGF6DYgMn9MsLForddZQS
uklaeuKcluKmdnQaIc7akRclBeB9GflIGeS+49e9HqGLqrS/+L8DC1sEzIMrk/DL
BdLBDD7YOK+SzCChkJNbuPZ4KFt7eA6OWkdLAcid6D51peiyWjBVgjDaO1wsIwOX
FILWj0+j+m/YSibc7dS+YXCTJG/u/iNGHE6nAxdgrPHNXxw+QzUTPTuezR5nMbdG
YCeqz0Sx7KBVnMI1G7XGcPbzrzRpW/In1+zq69ydJYISA//Iy9MK0UiqaqRyMfiu
EGYmtB+7KJV7//Fun0t7w6R6vmoPeTPNO+10vGc7qrDdBnrur9YV5O/rXqsHiQto
HWPCDP0Tel8/Int1HB3pNixi39ezT8fytli5a8m2rZcTNJMCFhFVpqSGUUKa0wkr
OtTtIVsIL8+ov++YDgoC
=HrKT
-----END PGP SIGNATURE-----

--=-zHs/FF7FOBJ5bjoSJVtS--

