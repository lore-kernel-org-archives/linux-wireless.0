Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34425 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZHZWbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 18:31:02 -0400
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: htl10@users.sourceforge.net,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890908261526g538eea56l873314e576331449@mail.gmail.com>
References: <850984.89698.qm@web23108.mail.ird.yahoo.com>
	 <1251297273.15619.11.camel@johannes.local>
	 <43e72e890908261333m1d576fdhaa16088affec5426@mail.gmail.com>
	 <43e72e890908261506h6b9ec4efq2d190388663d4671@mail.gmail.com>
	 <1251324755.20531.0.camel@johannes.local>
	 <43e72e890908261526g538eea56l873314e576331449@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-If8eryWXgIQfXxvvrGgR"
Date: Thu, 27 Aug 2009 00:30:24 +0200
Message-Id: <1251325824.20531.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-If8eryWXgIQfXxvvrGgR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-26 at 15:26 -0700, Luis R. Rodriguez wrote:

> I was thinking of the case where someone hit rfkill between dev_open()
> and mac80211's subif_open() but I am either not sure if this is
> possible.

Oh, but that's ok -- we'll set the interface down again very quickly
after. Besides, you could be in subif_open() already while hitting it,
somewhere in driver initialisation...

> If there is a real value to adding it to mac80211 then we wouldn't
> need to tug around a hunk for it on compat.

I don't see any value in it.

johannes

--=-If8eryWXgIQfXxvvrGgR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKlbd9AAoJEODzc/N7+QmamW0QAMjpKGOWw0LIqPOjIZESwgdA
I6zSNaIqF2yuBkAVy0uQejvH7BUFyRKJiseNKZEIkkXwA/ZHS1fWiFy8PNy505iS
9gmYX1a386ypvt5h+iAnH799VkjuEoXbeMSXCLsJ17jWL6aZwuDto1RDwFSZWpCb
/p/Pv+AbT8SM9y74NOpcRemCAtqA+qoUBi9JRiuQgbIovNFdeppf+Dh+ANvliwZ/
jdYjzbebAchYNnnx2fuuaIuitRNXUdSKWf1efJ1d/aXhDniZiHkIaWBqsy4GZ+0C
coPCTov/9UGVHowuQtptJzPfuW92aevKKx85B2wXovFeVIXkjc2QY6ROK/qVGeLE
XtTeKFmzqHF1Mu+h+QF/Nx6Sv1HO7cB9Nr26UNn0PY1CXMBrrCaR3Cy3b+NdXS/E
GSLYfYholA/YUs4cTBY/+UHC+Np/BeY/xdnYjE/BihgbeilhT8T4wHl7Kz1w2/30
GJLNWmdmj/60cTcXtvXRh3PtEvNx6zjmZbSD4BEKS6DXtX6wJY136IIiwvvmxG3I
SbzWGjzrhxtzI2PwN32ChBOk/M/QdiP04zVbFtExc3e54VZo9SvRV0qroK/gwumG
drYfqDQNaViRgBl+uMTICGkVNMCVLTgj5nwrTugY89Akbvh9xJ9018C5CbZ+ztT3
NbLhbcFsN9gRqMkQAXHp
=K4/Z
-----END PGP SIGNATURE-----

--=-If8eryWXgIQfXxvvrGgR--

