Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab0BSSYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:24:18 -0500
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs
 definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <69e28c911002191021w1a1d9656oa762724e398da212@mail.gmail.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
	 <1266591292.15178.1.camel@jlt3.sipsolutions.net>
	 <4B7EB31D.2000603@lwfinger.net>
	 <1266596602.15178.2.camel@jlt3.sipsolutions.net>
	 <4B7EBF0A.1060907@lwfinger.net>
	 <1266598974.3754.0.camel@jlt3.sipsolutions.net>
	 <69e28c911002190906n647d1a25o5f7268c585fa05c8@mail.gmail.com>
	 <1266599361.3754.2.camel@jlt3.sipsolutions.net>
	 <69e28c911002191021w1a1d9656oa762724e398da212@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NtO455jiGCBiVds/k1a1"
Date: Fri, 19 Feb 2010 19:24:13 +0100
Message-ID: <1266603853.29775.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NtO455jiGCBiVds/k1a1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-19 at 19:21 +0100, G=C3=A1bor Stefanik wrote:

> >> Hmm... rev8 SPROM in an N-PHY?
> >> Or is this a "low-cost" N-PHY with actual N support disabled
> (similar
> >> to Ralink RT2070)?
> >
> > I have no idea what you mean by "low-cost" N PHY ... this should be
> a
> > 2x2 device.

> I thought it was a device that was based on the N-PHY design, but
> without support for any 802.11n features.

FWIW, aside from the discussion about SPROM formats which Larry
clarified, there's no such thing.

IMHO a manufacturer would have to be immensely stupid to build an N-PHY
design based (!) chip that doesn't at least support MCS rates 0 through
7, i.e. 1x1 11n operation.

johannes

--=-NtO455jiGCBiVds/k1a1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLftdKAAoJEODzc/N7+QmantEP/2wxmAkGIus7fUhOEdrBu3fJ
0Bbs6fDa+uxsb8F/6x0PLmZcDS7dUNc2PVg0H4CNna/rgPwvDjITavvQ7SzA6O9p
eJWUBuS2QAs5aZ+JUvXq0h0B4o6cmJ/wvI6L8mvQIbHdcYFKybH7NrR7k6N9KX7r
zBbiIDhqnrqOgNhpxxL0VcQtpqvoLYNdc3wfgQztz8udWVN5mch+z4/o33v9rCKO
QacDGncoM+y2/roTFPq8ZjZgtgC3Lw2+XqQZMGzw0F0wZujbOCg00cb6ujQzHs2x
+HQe+cDQRJYJk9iUAQMgUS5EG6FrasDFah/oB79OK9YQcuNwAad2ShD6c0txY968
NMpovGKAFBBSpD83hOhCV5ELAYuoGsqvhiZMkFMxHKFqnUusoraWdsEGi/PtBgIn
Zt5VTN98qEPuUQ0AUysEyi25CjBZxw1MU6KpIFkwPLJ7jYe7JHiDOGwmn5UHlC5A
+/tJy4iROaqYGvdHTMWyfxedXYmZJ0AUaDJ/CSmS87541pzsPUFkMtx7aO/4rffe
/av6AW9amQh5VWqIrV5lBYxSnKzQtktEChHSdfXWL+zHaQ+NfBjGMpBQ3yWj/HkB
GkKnnhlEL5L0YquqQjTYrcqn+HBm/z0HLc1FtdxsLL+zO95kPaTNoi2VAeXsGMsx
YofQSsHjGi/ZZNLJGEKY
=ozxt
-----END PGP SIGNATURE-----

--=-NtO455jiGCBiVds/k1a1--

