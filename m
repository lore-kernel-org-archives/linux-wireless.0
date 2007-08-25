Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760054AbXHYH5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2007 03:57:00 -0400
Subject: Re: [PATCH 08/15] cfg80211: clean up key add/remove interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46CF298B.7040001@lwfinger.net>
References: <20070824122705.549190000@sipsolutions.net>
	 <20070824122907.784517000@sipsolutions.net> <46CF298B.7040001@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iYaQ/K59dk13ZFIa7PBO"
Date: Sat, 25 Aug 2007 09:57:40 +0200
Message-Id: <1188028660.9529.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iYaQ/K59dk13ZFIa7PBO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-24 at 13:55 -0500, Larry Finger wrote:

> I found a compile problem when all the patches were installed in that 'op=
s' was not defined in=20
> wireless/core.c. This patch should be
>=20
> +       WARN_ON(!drv->ops->add_key && drv->ops->del_key);
> +       WARN_ON(drv->ops->add_key && !drv->ops->del_key);
>=20
> and not WARN_ON(!ops->add_key etc.
>=20
> A similar change is also required in patch 11/15.

Huh, odd. Seems I somehow messed up this series, I'll look into all the
things next week (busy over the weekend)

johannes

--=-iYaQ/K59dk13ZFIa7PBO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGz+D0/ETPhpq3jKURAnuYAKCgutll61oWXOaBWaW/sAZESXVILQCdECo7
auW+fhnR4tDNjLopFvJGa+0=
=OA+k
-----END PGP SIGNATURE-----

--=-iYaQ/K59dk13ZFIa7PBO--

