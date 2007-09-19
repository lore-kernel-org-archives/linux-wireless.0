Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875AbXISKx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 06:53:28 -0400
Subject: Re: Please pull 'b43' branch of wireless-2.6
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, sam@ravnborg.org
In-Reply-To: <20070918202819.GI4940@tuxdriver.com>
References: <20070918202819.GI4940@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HekZdaPgA6zgC16Pp5zX"
Date: Wed, 19 Sep 2007 12:54:28 +0200
Message-Id: <1190199268.4414.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HekZdaPgA6zgC16Pp5zX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-18 at 16:28 -0400, John W. Linville wrote:

> This series adds the b43 and b43legacy drivers, as well as the ssb
> bus infrastructure upon which they depend.

Shouldn't we be getting rid of bcm43xx at the same time?

johannes

--=-HekZdaPgA6zgC16Pp5zX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8P/k/ETPhpq3jKURAjbJAKCD5wEGMGHSnu8rTnt5BrRbxieuYgCgq2v+
AbMzibmQnjQuEv+rsy5VnQM=
=bQ74
-----END PGP SIGNATURE-----

--=-HekZdaPgA6zgC16Pp5zX--

