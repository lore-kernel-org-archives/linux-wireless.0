Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32993 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZEHJQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 05:16:56 -0400
Subject: Re: [rt73usb] Master Mode almost done; problem with ARP
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexandre Becholey <alexandre@shockfish.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <4A03F67B.1000101@shockfish.com>
References: <4A03F67B.1000101@shockfish.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WTjtILtj+B4wed3m75vC"
Date: Fri, 08 May 2009 11:16:54 +0200
Message-Id: <1241774214.1567.34.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WTjtILtj+B4wed3m75vC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-08 at 11:08 +0200, Alexandre Becholey wrote:

> And what I can't do:
> - Computers on the LAN can't ping the stations (Destination Host=20
> Unreachable)
> - AP can't ping the stations
>=20
> I ran wireshark on a computer on the LAN, on the AP (here I used tcpdump=20
> on all interfaces because I don't have the possibility to have X) and on=20
> a stations. I would say that's a problem with ARP packets.

Here's a similar bug -- the debugging I did there you should do here.

http://bugzilla.kernel.org/show_bug.cgi?id=3D13237

johannes

--=-WTjtILtj+B4wed3m75vC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKA/h9AAoJEODzc/N7+Qmay4cP/iWGt3qd4xKNJtu/CFhpXGV4
nZ+BmWnIkgO7BLhb7Kfqi6pibHORgUb6HBJMmrcMaHfI+cn7fNyBjvdMv1yczkxa
zOie/HY2uWVLU9nDn+DDmqCl6NGbxnB4EKibSOfbtdW+C5cpaIGIFlm5lFMsGdwt
yFDBwejbEhm2v+eZSOkEIQh5OL4TpSevUpCjOzp26/sOnffBxzqaJ14AaEErR2iM
0dyLo5CB5yV5VOVw1ej4j/BgdYf0e35LC74PhV2e3mcqIKPfvmA3qlM1A8eQN1WR
+tMw1FZWKa/L8B+cnfdqvD3y0jjsw/ata0PtnJBVpuTB9UimPkbqjqLO9LQGQUfK
/v3flsQa+Pfu2FapUQAMfGRvCun4JnA+2dgGeVqC5g1vZBiFE781GfZnF1xdgYyy
U8j2jNX8N3OxoI3zUnLxSWBto/8SEzR51t2Z+QUi08dF4NeWCUCsQ85DERMo1e4e
RpqyP+1lbtNKEY0v9UgC/ftRZCYAdFivbGIeSloAw6Bdi4ijU9TqgJtXwyivnBg/
XEEDfYjhWfuPqZch7jJBdquaaWIVddl8kP+bzQRnpyQe4b5vqfPEGhHOd1KX+I7w
y56cmvXkW4aJ9fEva51/4EloORTmbELJ+YanevXw3vNIkJ3I1CRMbV0CjoMTirUQ
Su7JTOZ7BkM39pI0PZBD
=enq3
-----END PGP SIGNATURE-----

--=-WTjtILtj+B4wed3m75vC--

