Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYBYU4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 15:56:55 -0500
Subject: Re: [PATCH 07/13 v2] o11s: changes to ieee80211_sta
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203973009.6929.77.camel@localhost> (sfid-20080225_205513_267083_C0F6C98E)
References: <47be773d.22b38c0a.2fbf.ffffb131@mx.google.com>
	 (sfid-20080222_074745_247391_EDD9C862)  <1203697317.7082.68.camel@johannes.berg>
	 <1203972580.6929.74.camel@localhost>
	 (sfid-20080225_204804_927071_F77C43A6)  <1203972564.13162.165.camel@johannes.berg>
	 <1203973009.6929.77.camel@localhost> (sfid-20080225_205513_267083_C0F6C98E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RHc80K9/rwvU+c5M7vcd"
Date: Mon, 25 Feb 2008 21:56:47 +0100
Message-Id: <1203973007.13162.168.camel@johannes.berg> (sfid-20080225_205658_687505_533E04AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RHc80K9/rwvU+c5M7vcd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 12:56 -0800, Luis Carlos Cobo wrote:
> On Mon, 2008-02-25 at 21:49 +0100, Johannes Berg wrote:
> > Can you do things as follow-up patches that apply after the sta_info
> > stuff I sent out today? I'd prefer to not respin the 11s and the
> > sta_info patches.
>=20
> Of course, I have to test it first and everything I send from now on
> will be on top of that.

Ok, great, thanks. Remember to remove the " && BROKEN" from the Kconfig
before trying to configure it ;) Oh and you should also get sparse and
look into the warnings it generates when you run

make M=3Dnet/mac80211 C=3D2 CHECKFLAGS=3D-D__CHECK_ENDIAN__

I haven't tracked through them yet but it looks like some endianness
conversions or annotations might be missing.

johannes

--=-RHc80K9/rwvU+c5M7vcd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8MrjqVg1VMiehFYAQLXwA/+IuHutpzX2UqAbTekn/21YPHhGRO34GPl
jt8kOCae8uj+o8wDC8qUKpMCoYKAeORWyI+UXVB9bsks70JshuQjvCb9INWN3I7T
5Ki6j0MlSTSuxoLixLuH8gbYcB4+2LYAXj2RpbWrLhxzVs2riTBzccQfH2DMBI+T
vnIOSt2F9VeP1wKjgg/VE8eelng8OEsQcVuA1vs72KFIXKp1ViKXK9488ZCphmDP
/IoaPHxnBBHXHkT+VP5Mbh1o3u60Q0ZLvMyHaQ5r4kLNJvHZyjyiRMGnzPNAZm6v
nRoClUS5DayJeCMDAyvblEs1ZS7PMPp5jmy+FSsQWiT3sxPdLlDxDlbBO1yXFcEf
qtt+N2NbooAh0Qv0qKHWiqYdZOFhHtSmXMMpkhByPidVyMEw2/ITsLa7qdW++a/F
OoPj1+uZDqpJyqx77V2y2ATPaPuZ7WdBO6G5MGYrBLPc/uzJo7RBkmiOt4QG+APT
CU9XNiW+kYvmXlJ5zbX/z8507WvoaRWq2rLjoY+aeHtfK1cXBpwXB7QwvnAFhNdA
UGcqlIfzvkzkHjOpRMFls8EV5/CL9XWrvY1i+7OLlkb5ZwQ+uL6ayPs1YuYyWfNQ
mq/ZT8ke1/cReHba7FuXO0BbBIF4KSmW/7z/2Tf2xtunJhwZOf8+dWSdtP/9i8Tb
BYauN95PEZQ=
=sg5K
-----END PGP SIGNATURE-----

--=-RHc80K9/rwvU+c5M7vcd--

