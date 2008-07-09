Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbYGIQHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 12:07:49 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091808.18664.IvDoorn@gmail.com> (sfid-20080709_175930_612304_B9C46F05)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091748.49796.IvDoorn@gmail.com>
	 <1215618570.3246.30.camel@johannes.berg>
	 <200807091808.18664.IvDoorn@gmail.com>
	 (sfid-20080709_175930_612304_B9C46F05)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0f0wrUuDFtNC3pgzKTpc"
Date: Wed, 09 Jul 2008 18:07:01 +0200
Message-Id: <1215619621.3246.37.camel@johannes.berg> (sfid-20080709_180754_956454_C41060B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0f0wrUuDFtNC3pgzKTpc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 18:08 +0200, Ivo van Doorn wrote:

> rt2500usb: Not per-frame, it can only be disabled globally
> rt61pci: Both per-frame as well as globally
> rt73usb: Both per-frame as well as globally
> rt2800pci: Not per-frame, not sure about globally
> rt2800usb: Not per-frame, not sure about globally

Interesting. The reason that broadcom firmware allows to disable
per-frame is actually to implement the per-TID counters in software.

> Note that I don't know if these devices handle the TID and the not QOS se=
quence
> counting in the hardware. I'll have to consult the specsheets for that.

Not much we can do about it either way unless you want to always disable
globally.

johannes

--=-0f0wrUuDFtNC3pgzKTpc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdOIiAAoJEKVg1VMiehFYecEP/1u36PL/IBdGQWoxrutwguLo
BHVBv/BoM3H86siv6o8mEAsG7mEUY5YkFhkxHYMsjnnfy11/Eh7ZOQlkLqpR/Zqu
NqA9Edk9NlT+m5XAk6gdyT5uFwXKvy9VpUaeKFM8Or6ZxQ8p5i96dojj2tw6Qgh9
y1AjGi6EUIUUn/O3sfxqhb6TY8NCJbu3mlqZ8bpzSGFDWTn007uuZDDuZB2x1rve
69m3xTmoOEIFe2kbxiDXuPXGRdt/yTFJ0jJXidLt7aqjLz9KraLPyjofUJ/tb10y
RxWkYIS3tur57T4CvJkhQrBGMFyvSXys7HGvNjWC3K5sCioVmFAz49NKbVAlVV8r
XzjTJKhQKeTZ0iwkkd3xQIvbei4jaVzTUQQtOILJFC8ANqteXibqlSHH0EgVAoTZ
e3Ah7E2kFWPJ+teouJRfCG6jHsPEG9YvI8ouipBLOOTp2AyrXeZsBDmauZqlgVk7
JiyLBSZzXaQYtNehZLUWQQ52dxR7ehJFkHswBDmeug9B6XInYjlFGXnHdRZKV3bk
6IUsmA2FqJtdQneQ/7psVdB42pOXpZBuQSNHpX6P3O7A6BPAWKY1mN/Su8VQIBBM
sDO5gX4I5RfADrUgQnQAGAFDWjQftTryW0o8KwI8M4wkFWh/YSeNO42k23f8SXPS
YRWHz3uLP+WIIB1aXiKD
=/vti
-----END PGP SIGNATURE-----

--=-0f0wrUuDFtNC3pgzKTpc--

