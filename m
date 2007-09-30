Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbXI3OnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 10:43:16 -0400
Subject: Re: [PATCH] iw: misc minor updates
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Kershaw <dragorn@kismetwireless.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070929232006.GQ12844@drd1813.lan>
References: <20070929232006.GQ12844@drd1813.lan>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DfjzV51aWS2DwE1vxWkU"
Date: Sun, 30 Sep 2007 16:44:40 +0200
Message-Id: <1191163480.22960.168.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DfjzV51aWS2DwE1vxWkU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-29 at 19:20 -0400, Mike Kershaw wrote:
> Miscellaneous minor updates:
> 	Fixed char *phydev init in main()
> 	Whitespace cleanups
> 	Minimal help
> 	Aliased 'master' to 'ap' in nl modes list

Thanks, applied with some small fixes. It'd help if you could inline
patches and make the description just in the mail :)

johannes

--=-DfjzV51aWS2DwE1vxWkU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARv+2V6Vg1VMiehFYAQLwVQ/+LaNTL3ZVHraSVMMZoBapEYC+j14JKYys
Jze6Xdv68CiSkGNdoSlJl/RuBgLlP5svICyAixNVa4K7k9G08m9o5A3e6x6Fr1Km
UQpCXY/TvOCceCtcD+pkUIfA2ri+tPj8yjgiIxZ1LRCpvNnIZ12Gf92KpFYAaLl7
FsU6cO1gXOwIYPCdWQMTke7kJswSkcG6BxbZsjudRdc+OYv9NzSFDMIlRzHrwQNa
fPMl0DaCSL1FR/PPoGiF6WMYv7D5uUXtqHpRBfifh50py5iNoGJl6lZCZVmMnaSg
p0MDB9kSVD9IyPoAvXmClj4PH2I3xi+tf3RZYla7/9j/b7hzKGh0hp1SRCMBFzcO
AptLm43BQYfL+9Ry67lN6ydmRRdf0y/gw/xmY89ZYSE0ZJ8jhEv1ZPgUxN0Ny9Xl
3Wc/RMHzNyliUwi+4dUqTrSAuWkmiwh093hy1No1FhJ0h6GoXBoW9FjPuqBIvGWM
6ef+bj/wNbTG5AdoiT3V34J2B3latVY51MS3uU3zNjfdbSZ8+JgnNETBjdX7dW7X
H/I3ODGmBFwm7LTegcGWspG+cnxAiL1ldhK/VwNEM4Z6qWY828pp7PHr7oK6rN0O
IyiQ+HU1wc9+CfVGMEoMCDcA406BzXu9K+veDGAoG8uK/TorftftoAl7WJbTtxQq
8rTekKB9ODE=
=vaok
-----END PGP SIGNATURE-----

--=-DfjzV51aWS2DwE1vxWkU--

