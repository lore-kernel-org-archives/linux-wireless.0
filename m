Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbYLEJlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 04:41:35 -0500
Subject: Re: [RFC PATCH v4 5/5] mac80211: track master queue status
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87r64ni2yr.fsf@nokia.com>
References: <20081202200219.5507.83250.stgit@tikku>
	 <20081202200426.5507.44042.stgit@tikku>
	 <1228412076.5692.25.camel@johannes.berg>  <87r64ni2yr.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cPvR9s4Kx9+PJUq5FVIH"
Date: Fri, 05 Dec 2008 10:41:33 +0100
Message-Id: <1228470093.3970.8.camel@johannes.berg> (sfid-20081205_104154_464024_20D01E25)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cPvR9s4Kx9+PJUq5FVIH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-05 at 07:51 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > I wonder if we should optimise the spinlock here?
>=20
> That would be nice, but how to do that?

I only meant to lock/unlock it just once instead of for each possible
queue.

johannes

--=-cPvR9s4Kx9+PJUq5FVIH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOPdJAAoJEKVg1VMiehFYzz8QAJ0zBQT6BaLPGzXLZLw+lOu6
K+iYT9XNKl7sWywNoInLdWBXgFcCkl8wWaBYvNZUrPb00EmbA2KOWuVyjwokj0GF
/vfV6St39pclBoHJX7IKZ6PCYjjfvSdToDrSkNn0jtVGvaF49ED+G5SwJ3XbOXCO
C5tz0s0xuAF7azY/QhQFCFCcxSEZ0L/D1ZOO5OXfXAmCOvDB1VFo7pbCOLkJG82+
EHP+I5qH+bkWjCJedsln9KAiSnuDX2MsYx1pM2BJAcwnM8QrvFvd7l8ytnFl85s0
YGYz+Cr3GZ2VJNo+QQInIzymV3WJyTeqlqWsMMuMBwu/ls9FszbevdTHi+CLiFT6
noxiCirsbmpnXzP4f7oQmTeoaYFcMrry2kiJQc/4a6PZXXpUeHYvZeYFJjcQmZoL
mF07bv4Jcvm5//M0V0i5mxxzH8hZrgcLPrrOwB6vpZuPRnl4bhiC/IgjoWvNBsSr
g+kZoGBkoTl5T8FRcdXgmycpfi3qFlcmSY4riivPQZoYGMN0N+cGBcBPmWLSmXnb
M+9UARMX9VyghrbQruzoYF9/nyRZ/oCNJ9DGK+VPUkUwArIEAZBcFkCBMLDe+uan
M0JwrbWSzuaKxu1tMNQGF6/RuG2WlgG4O7nkFquCN0rUWTb6BMwXOO5g0uHoIjii
IMDNEc060k41wt+KTFLR
=ZHbW
-----END PGP SIGNATURE-----

--=-cPvR9s4Kx9+PJUq5FVIH--

