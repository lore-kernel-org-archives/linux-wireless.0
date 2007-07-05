Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbXGEMdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 08:33:07 -0400
Subject: Re: Multiple interfaces in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <200707042305.40944.flamingice@sourmilk.net>
	 <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7CuxtfMWOikVSt3ud8wz"
Date: Thu, 05 Jul 2007 14:34:05 +0200
Message-Id: <1183638845.3818.34.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7CuxtfMWOikVSt3ud8wz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 15:30 +0300, Tomas Winkler wrote:
> Does anybody have/ think of a patch that removes the master interface
> from the sub_if_list. It slows down the receive path.

Actually, we want to get rid of it completely. The missing piece to that
is decoupling qdiscs from netdevs.

johannes

--=-7CuxtfMWOikVSt3ud8wz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjOU9/ETPhpq3jKURArCyAJ413iNhtknnsS7c3jwFrxFS6Qns6wCfVnJl
U7MG65dld0WpgwaKISqKqXY=
=02Pb
-----END PGP SIGNATURE-----

--=-7CuxtfMWOikVSt3ud8wz--

