Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZAOJgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 04:36:16 -0500
Subject: Re: Userspace tools: Roadmap?
From: Johannes Berg <johannes@sipsolutions.net>
To: David Shwatrz <dshwatrz@gmail.com>
Cc: Dan E <trg_info@mailhaven.com>, linux-wireless@vger.kernel.org
In-Reply-To: <31436f4a0901142352u2b60f9e6n5940835f13658b37@mail.gmail.com> (sfid-20090115_085234_636643_75C8A3D1)
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 <1228723993.22164.65.camel@johannes.berg>
	 <31436f4a0901142352u2b60f9e6n5940835f13658b37@mail.gmail.com>
	 (sfid-20090115_085234_636643_75C8A3D1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JDFkUjkTZHp8MRVSXyhU"
Date: Thu, 15 Jan 2009 10:35:38 +0100
Message-Id: <1232012138.4007.1.camel@johannes> (sfid-20090115_103622_161494_DBDCF2C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JDFkUjkTZHp8MRVSXyhU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 09:52 +0200, David Shwatrz wrote:

> >>   For instance, how do I command a
> >> channel change from userspace?  iw doesn't have that.  >Should it?
>=20
> >Yes, it should, and nl80211 even supports it, but iw itself >doesn't yet=
.
> >That's fairly easy to fix, too, but then iw won't support actually
> >telling mac80211 to scan and associate etc.
>=20
> Can you please explain why addition of channel changing in iw will
> cause iw to not be able to support scanning and association ?
> (wireless-tools has all this options).

Eh, no, I worded that wrongly, I meant that it currently _doesn't_
support scan/associate. And nor does nl80211, so that's not easy to fix
(well, scan is WIP)

johannes

--=-JDFkUjkTZHp8MRVSXyhU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbwNoAAoJEKVg1VMiehFYks4QAKOT4hwq0e2AetgRsec3VI3K
tpa3XkQrmg9wQWIHlcFiW2LVtBiopVrjaCnuumwe1P+zvXCEhuX0k23sQSqic/De
d2cQavmYMKZlv97GLrNa7dsjpF2RZVOFcWQv/YjXXcKQblMv42GWsW8YS6vXiKYS
1J+BI45QkrKIa161umYMSgP5L7m9jDRgKQy2h/vzVrTKOgq5bgE4DzKdtgpN6KFP
qYV3293lJm1J0Z6gDKhX1yM9E/UMtETve5F3dFaxVy9f8rjlPvMP8mDTh4kIyVQW
2zSelWaP2sgCWUxrUTwT89mmZcts/CkNWzs6X3mwP0hBh4pTbM2Wms+yHsP1+tP+
5LPZpczrzeccNdr3JLWgPni/ezhBOQN/d2TLri+xnV5BH9oeg7IqHO21GU9JSC5V
KRGPQd/FZFyJnZWC5tCrDoFMLba+2yrxODwwrteALVSJCkdEZelCy9pUMPShC8oN
0nxqwA4tUzLQU8hRbZJ+pJTSuCFwhkMTx8s4FVu99bOT/aldMU56JK/3RNQDqeu8
7aZ74EcIuEzIyt+q6f45K/LyV3JZj8Pzzmqg0RPASdjjFeei7I29TpCNnihlfAsi
ay2YNRH/+nOyxKjNDFLhYWF4pOXbbMHyuNgd5sPb2enRdkDfVuTLO8mFizFxHEZa
dAa9sgyjbgY5ECgRYwWn
=W5Tk
-----END PGP SIGNATURE-----

--=-JDFkUjkTZHp8MRVSXyhU--

