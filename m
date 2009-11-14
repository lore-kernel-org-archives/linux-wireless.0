Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbZKNJgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 04:36:11 -0500
Subject: Re: [PATCH] mac80211: reduce the amount of unnecessary traffic on
 cooked monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1258190607.6167.33.camel@johannes.local>
References: <4AFE1612.5070805@openwrt.org>
	 <1258190607.6167.33.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z6E8lpgV35nve/gr7WbJ"
Date: Sat, 14 Nov 2009 10:36:14 +0100
Message-ID: <1258191374.6167.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z6E8lpgV35nve/gr7WbJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-14 at 10:23 +0100, Johannes Berg wrote:

> > +			if ((sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) &&
> > +			    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
> > +			    (type =3D=3D IEEE80211_FTYPE_DATA))
> > +				continue;
> > +
>=20
> This patch also breaks IEEE 802.11 compliance. :)

Oh no, it doesn't, wrong code path.

johannes

--=-z6E8lpgV35nve/gr7WbJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/noLAAoJEODzc/N7+QmarokP/3xVlUgZ9aF/4bRVqYYxp42C
rNs+YxfH+PQKdodWKN82s/+DddEGFT0WeIsH9zQ3jDW669yjTvpxQlK1lhyyQDEv
4mFR0XPvma7tZSsJrvyDa+kjH7Wn2KgYILXViJE+4i1EWUgHfB5TpKgMs/aimcNb
AShK9JMXvOUiL3Ba0vxDdtim3CeeF9cDafmpjkgkxI/mzq8DVLBuX3S3F3mFtI+n
gqLqu0Nq9eQo06/0ux9vUrCe+c/p4ooE2rR0tS+KTNe4mLWtFNY2raAklx6v+POl
mzUiS/u/+6NbvwB2jo8G9iAaFLZ6dv4kGVbJID4amSYFpmK3BgEqAh1lT8WmyjTZ
ip5pCS5PKAlDmCZxAsiEB0tQzJ0umt/SQTHLCp6bMZSk/eWagQLhARGz+3leqv6I
kHGfXoyohqpHcp4X6iAeg4MYyWRq1PueEkw/QEqgfqK6fqaW+eW6jQQ8uhhg95NK
0gOUEULSIakmQCmjHaLBxykqoDOp/h/p4Sbl8xiLLQajxFQILmph6PhzKz77qm5p
b+klRekRQZO9KC11QmNxTrlBUAXEl6uDVAThXAVGBbfnbscpvW0cwNOKNR6Adqek
XulqRKGohvtbaddXpdVDgR9pSUVNQLq1pUa/bwpGNl+TU3bWKUb+IkFBU5CXj65J
QbfKpQMXtfRt3Mcz7+ts
=Pn9r
-----END PGP SIGNATURE-----

--=-z6E8lpgV35nve/gr7WbJ--

