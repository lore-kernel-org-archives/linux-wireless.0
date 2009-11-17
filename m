Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39529 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbZKQHiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 02:38:07 -0500
Subject: Re: Adhoc networking, was Re: compat-wireless and minstrel
From: Johannes Berg <johannes@sipsolutions.net>
To: Derek Smithies <derek@indranet.co.nz>
Cc: Adam Wozniak <awozniak@irobot.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7z/oZT2h8KHf3ouHWzD0"
Date: Tue, 17 Nov 2009 08:38:04 +0100
Message-ID: <1258443484.1375.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7z/oZT2h8KHf3ouHWzD0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please everyone in this thread, trim your quotes.

On Tue, 2009-11-17 at 13:20 +1300, Derek Smithies wrote:

> Yes.
>   that is what the BSSID is - the definition of the basis service set. To=
=20
> use a particular BSSID is an implicit acceptance of the
> >>>> a)supported rates
> >>>> b)the value of X, the value of x
> >>>> c)the channel
> >>>> d)the ESSSID
> from an existing network.

No, point a) is incorrect -- it is the _basic_ rate set only, not the
entire rate set. Hence not knowing which rates a station actually
supports.

johannes

--=-7z/oZT2h8KHf3ouHWzD0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAlLYAAoJEODzc/N7+QmabE8QAKvOXuiICHiTIflPSMNGNnhm
yNCZZZjlrJIgCBReUTeGrxWO6tuQTPNl0aRrRZ4S7XjVdOCbXOpBNVNTH4FD3XXw
k03vKVUQMgxBHeexhQwoX1+IFpah7VFLuPXQXw9RxHpQqfgBJSl8yFLMpSF/oFui
bsgrS0xSbCdxZwZmbOPxU8uwl2+/woDne7XFA3L6Xpt6t5tMy065SWYL9urusdHG
dbxucPWhkTp5RDNIgr8oEVhMfJz7Mii2T2OE5AYTvfUkPBuF7kY6vuInkb86EbDH
iRzpGBqCKgAk3JsgDw8PDgGSj+HvvEJz6EEDGKr78x5GwkDIo2DKFBloiDgMmnS6
8avFzAqSkPUKLQ9g2AozMjlV+Ijw34252vtTZqDhxBKg6YA6E8vjTt8dqnjWM2gn
mcXj6W8vg10tI+WRKexBhHbZbYpDqwVY81ZaAEkcSpjYGvgBcKV4t3Mr7ToVl2Sp
oWjSVR8a5+sxluJi7r9qlI8xb/V2PcCuqJYqxRGwpcOhV69gByqgBLQU5pJdUbgq
pvfag9wj5aSmdRNdM/wlUk5VfxBgrIsKXqmya+vGZuNK9xoo+/CmO4BS4g0ZAgEB
noeLHCkT/d1gKIIWqp/il5Lgd1xQw9I4NTN2LkiH7TqGdq1PYTvyP4VgJLmG2u64
EELE3IASL7TZCKS2pXYn
=f4Jf
-----END PGP SIGNATURE-----

--=-7z/oZT2h8KHf3ouHWzD0--

