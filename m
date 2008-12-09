Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYLIVMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 16:12:35 -0500
Subject: Re: [RFC] mac80211: Disable requests for new scans in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <1228853236.18616.1.camel@localhost.localdomain> (sfid-20081209_210814_025117_B90F808F)
References: <20081209145722.GA2285@jm.kir.nu>
	 <1228844410.17539.1.camel@localhost.localdomain>
	 <20081209193351.GB16905@jm.kir.nu>
	 <1228853236.18616.1.camel@localhost.localdomain>
	 (sfid-20081209_210814_025117_B90F808F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yXB8qfvBDvC4WIpvFFcf"
Date: Tue, 09 Dec 2008 22:11:41 +0100
Message-Id: <1228857101.1029.20.camel@johannes.berg> (sfid-20081209_221238_798218_2617DCE9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yXB8qfvBDvC4WIpvFFcf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 15:07 -0500, Dan Williams wrote:

> NM only knows about devices that NM controls, thus we can't have NM set
> up the device and then subsequently ignore it...  However, at some point
> in the near future, if we can get reliable information as to whether the
> driver *does* in fact support AP mode, we can make NM drive the
> interface in AP mode instead of IBSS.  The only reason it's using IBSS
> right now is that the driver support for AP mode was so inconsistent and
> buggy.

We can get that information now, iw already prints it:

johannes:~$ iw list
Wiphy phy0
	...
	Supported interface modes:
		 * IBSS
		 * Station
		 * AP
		 * AP(VLAN)
		 * WDS
		 * Monitor
		 * mesh point

johannes

--=-yXB8qfvBDvC4WIpvFFcf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPt8KAAoJEKVg1VMiehFYGoIP/RXYLZNi2vPDchTy6uuWWpyd
CngoMyuUJerSSeYyhilB7CADpHZnOVkCtCSIU1/AZmct9BN21GarLcrLtJ2yS7p0
3jJdmnWBwqnUSN0X/QG6FMzxr12dSk0/Bq1u9VSLq2XukxJGVofpQGmXn5p8wlgz
qVkXx8vHHMfxMnWy0FustpyAmVjNviWfg4hrAXgWPM6vWT4FNstInJGR9d9tThK0
J/cmB1asIXz3vOJqHZAt2OP+Kq5ikc3yw5PRswVbbrPKoepMwwy6hnmLta/hCsK8
DlF3Hjballdu2jl1CJc1zpOGHe/ug0AcWHmQWsO0yVCw/fxz2fpIkCflxrec/ggk
SIFTHyJRcC28mxXjDsF05LRTMOqVW+ls3v0PkOb6wmJLzvx50mWd2sMjsgOp5D1t
lpKjum7JlAHWAvFuODoitRozwe39PyT2rpJOBgs5Qig0LU95MIC16IhNrWu7Xxs7
BgUe2596yVxWAVIbGztPj1v4LUhjccgHXsc5nKoCHD3G4LILoU1KRSVjJCGOZDwT
H68Ji075mziu8KoaA62ZHHyc69GE9F+3RzA8gi0Ru3J9Ma7JpBEyn9S1VGaXvFSH
gcK8HNLVpaQVeT325koZAavwLme4Qe0w8PLZYdHk8FMs43A4MuztCScqjg3GbR5w
6cztWL7pDnNN9s32tSNn
=3CF5
-----END PGP SIGNATURE-----

--=-yXB8qfvBDvC4WIpvFFcf--

