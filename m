Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYIHSNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 14:13:22 -0400
Subject: Re: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1ba2fa240809080953mfe2ab86l5417679e4cb29df1@mail.gmail.com> (sfid-20080908_185305_511506_7FC46CC6)
References: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
	 <1220885742.31304.67.camel@johannes.berg>
	 <1220886337.31304.71.camel@johannes.berg>
	 <1220887018.31304.74.camel@johannes.berg>
	 <1ba2fa240809080953mfe2ab86l5417679e4cb29df1@mail.gmail.com>
	 (sfid-20080908_185305_511506_7FC46CC6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O3d5Kbe9ihXLU6wty7by"
Date: Mon, 08 Sep 2008 20:13:14 +0200
Message-Id: <1220897594.31304.83.camel@johannes.berg> (sfid-20080908_201326_712726_15619D11)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O3d5Kbe9ihXLU6wty7by
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 19:53 +0300, Tomas Winkler wrote:

> The bug is that scan can be triggered in STA and IBSS internally. If
> you request scan from the application (iwlist) while
> internally scan is running application won't fetch scan results
> because the -EBUSY is returned on scan request.

But -EBUSY won't be returned if that same interface is already scanning,
then 0 will be returned, so I don't understand?

johannes

--=-O3d5Kbe9ihXLU6wty7by
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxWs3AAoJEKVg1VMiehFY0C8P/iMyQVzVfmDKwPQvMC0yvd20
j2p/46ESnO5ULI6/TmA1Fuoeyu+6gQfkgGhMAWVnSvS9d07Hl5yKvrGlSu719c8D
QHxjGQTFNyzGeLjRKY8rE11ozVewfEVQ7JuXaBQeRIZFUXx+aQpPug6kFies4x+n
wRuIlbtoG14q+Z8csbfUt+AIf6QuyjKmmo12YR8njFsAD23Qp8pD5+7JIy67vh2a
a8Qa/3TXgAtfhddrcEq5SK5tM6iccAtPt8VNSRJ9eigWdvWiIoKYcRPfFBYNgdis
LWp0ZK+B757ADo3pRdy8FDPBZK1QgbwThM0BAMtrzLZ4GO+taCsdcQsurZVEhFmq
lLuQwhgsWHbC6cKh8RiAqLiHvwNFJpwd2YYxeKBkcUZK5NtEU3PP3v9IjzbaPZIN
Xl+tj5SfV352E2sDcb7FdbZDuLyk5RAk+DQyToFYsL27g1Ur9o8G08DNXmbhBl2y
Fnu5okg095+3dP85iiZvYBxvA+Vj3DXMAAdHmCNqi7PBySk5OSPJq+Ga1yJQjBdq
UPkrfNAH9vIQlmTqljaWy8xbONXVY9h0vatTjmfQ7TF8kwEl9h6Q239AisrwoVTV
QXpHR2PZDTMly3E31AIUGyU2wSuSo/6B7ynfdtFTctsSulPXbWJpMv/SELExJ7i5
6SptgfcnSVEeFxjkNwKx
=G+b5
-----END PGP SIGNATURE-----

--=-O3d5Kbe9ihXLU6wty7by--

