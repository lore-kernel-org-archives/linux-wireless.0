Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764792AbZDBWJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 18:09:39 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D5352D.2030108@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
	 <1238689637.24708.41.camel@johannes.local> <49D5018E.6050001@lwfinger.net>
	 <1238696967.6137.5.camel@johannes.local> <49D506FE.5070405@lwfinger.net>
	 <1238698084.7630.3.camel@johannes.local>
	 (sfid-20090402_204842_882765_82560824) <1238698667.7630.7.camel@johannes.local>
	 <49D521BF.2080301@lwfinger.net> <1238705420.8363.14.camel@johannes.local>
	 <49D52D27.4010607@lwfinger.net> <1238708385.22126.4.camel@johannes.local>
	 <49D5352D.2030108@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-C2IOSZl/5BeT6WLkstqS"
Date: Fri, 03 Apr 2009 00:09:05 +0200
Message-Id: <1238710145.22126.8.camel@johannes.local> (sfid-20090403_000956_381052_CAD5CEAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C2IOSZl/5BeT6WLkstqS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 16:59 -0500, Larry Finger wrote:

> > I'll roll this into my rework patch.
>=20
> The whole thing gets a Tested-by: Larry Finger <Larry.Finger@lwfinger.net=
>

Added; Thanks for your help and patience testing this!

Just to outline the plan at least once: I'll repost the patch after -rc1
(and after that trickles into wireless-testing), when a bunch more
drivers (I know at least some sony thing) will have been added that use
it, and I hopefully have toshiba and thinkpad conversions.

johannes

--=-C2IOSZl/5BeT6WLkstqS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1Td+AAoJEKVg1VMiehFYGcMP/A8kvSf6ig32ZiTEFmO4xJys
iiOSfqSBz15hfI0I2wipA31ynpNPoANpt40YDlvTTPsXAwED7JAvYdIVwIyv/3vV
tD+NcERroFsnboOYWy9w5/I1Ozk2ZUPogjSxRRb7ERu3vNMft2K3DWO5XJAfBcr0
DwZVa+cvC3mvPAipqYyV2Ci6Y0JjVTzHc4Wbc1O5pd+faq01hIlhXxa0CGBJ7t7l
XE2QkziCfznGXWRL3d0FWrkLtMEy2LbrZeIzvIZpQvW5zTBwC7XQ7IcvZpEvv0nq
3nvl6QPH+n0j0R1xjWXkJjlkNyq7T0uTYQ+qPTE365Rrbyij3i8SKdYfqODQ7A6D
94CsPCdpCgcVzDbwniYBRQ0jHWZMvvdPCuK86051R4n45+4G7oddpe7jrfHyQLI6
3E4vbPaKUsVjFKNRuw9veSCI7UgT2kzardSduGh4zu8W+KQOTADWmtePG+wp2z5G
UE6ItxeHi+kTPKyi0D9xh9Nf5tD9dB9fkLG/kzz7aVQjNUuGb1PfvXgqkl5J4FMJ
p4BeWm8hou1upLa2ueF+P25gk6pEyzLE0AN0slyQJ9G+OOwKGjGmtlfQpv+8QeFW
VExcPNwFwFJjUybwFK+9MB+WQGPH6SQ1+TzE/5l8KIV3buS20ZcXSKYklDIdid+G
5A6HVP+E/5Q8ZtwqQB/V
=YOiA
-----END PGP SIGNATURE-----

--=-C2IOSZl/5BeT6WLkstqS--

