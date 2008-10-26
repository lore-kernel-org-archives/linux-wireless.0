Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41201 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYJZJH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 05:07:29 -0400
Subject: [ANN] iw version 0.9.6
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Colin McCabe <colin@cozybit.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-owCyk40ESYOz7NDZNHZ1"
Date: Sun, 26 Oct 2008 10:07:24 +0100
Message-Id: <1225012044.3478.40.camel@johannes.berg> (sfid-20081026_100734_167192_D15C4D30)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-owCyk40ESYOz7NDZNHZ1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Just a minor release, which adds:

 * bug fix for it hanging on dumps
 * some HT parsing (if your kernel is new enough)
 * some mesh attribute setting (ditto)
 * 'iw event', sample code to print out nl80211 events from the kernel,
   not very useful as the kernel only sends events for phy renames now

Tarball is at http://wireless.kernel.org/download/iw/iw-0.9.6.tar.bz2,
git is at http://git.sipsolutions.net/iw.git/ and documentation is at
http://wireless.kernel.org/en/users/Documentation/iw/.

Enjoy.

johannes

--=-owCyk40ESYOz7NDZNHZ1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBDNGAAoJEKVg1VMiehFYfU0P/iwSKExV4c8nHNANDuxn77TD
Y7BwEuj5S5uWmwNUQ1EuV93Okul3cq6k3lNqzkgTc/fuIhq8QwKwrtDqBCGOd/Y8
sskss1WCydlrRmWZ4NJYyVUKYsyX3akgTbXq/RPdXQiev+AqxfREkn8FT4nhwXJg
LVxA9Xwiq5CfBqnG0UJK9nMJvz9V3riWoxcAVYk+sJEYQublUFv47k533G8c+lzE
UeilwjJaWVLGPqL0Cfx2E6OOnJmW4cN30rfoG41+pbqyKtLhs68pMGX9eODs8Fe7
TPcNqtv9gtOxM94dqngiQkl1Gs3k1/edCQGDPzlstRis4T7yb+1FB2L2gCDuAYHD
wg8hYVafVaDGPe6HbGoDWoxg5HfYVv05GNoTzj1qmNXst30lVdNU2HJquiodsODb
eHYyfxtNlUjCkCYsvmtCKU3/EtRIreIdDxeCApJ5/0zZoVNNbT+EdUmB2SE+N6zi
TNsqM6gtSnQbzcyoxvuZWgiZpS4wm/FBJmzBTILGSGfOrlBe9oEGnwtPOfaGesIw
G7YIoifPnbc1Ja5LtunYIss2JHCeYMXRFpjL1zJc2oyjZJt53cpG86SgKxvwEE/x
/98wSOD9JmUb5jrkLPOu1OkoBI0pXiDTKQrrHjYEf3kBAOKJnHBE/g15TzITqz7h
YcCHEDzCP88pay8633ZQ
=0GM5
-----END PGP SIGNATURE-----

--=-owCyk40ESYOz7NDZNHZ1--

