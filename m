Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZELWVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 18:21:30 -0400
Subject: Re: [PATCH] mac80211: make noack test available
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910905121518p44889103k4282fc3bf60e44f8@mail.gmail.com>
References: <1242158740.14227.12.camel@johannes.local>
	 <69e28c910905121513t5436ec52u47d0c49657000090@mail.gmail.com>
	 <1242166545.14227.13.camel@johannes.local>
	 <69e28c910905121518p44889103k4282fc3bf60e44f8@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ny6s97a4RxuDIJ5NcKIM"
Date: Wed, 13 May 2009 00:20:55 +0200
Message-Id: <1242166855.14227.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ny6s97a4RxuDIJ5NcKIM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 00:18 +0200, G=C3=A1bor Stefanik wrote:

> >> IMHO the
> >> unset-bit operations are useless, given that both TX_UNICAST and
> >> TX_CTL_NO_ACK are initialized to zero at the beginning of
> >> __ieee80211_tx_prepare.
> >
> > Probably. But it works, why change it :)
> >
> >> This also makes it possible to set
> >> TX_CTL_NO_ACK in a TX handler, which is IMO much nicer (not to mention
> >> that it significantly simplifies the work needed to support Radiotap's
> >> TX flags once they land).
> >
> > That seems to serve only you ;)
>=20
> I mean, you can put the noack_test check in a more relevant part of
> the code if we don't re-zero these bits in tx_prepare.

Huh? What part of the code would be more relevant to that than the bit
where it checks for mcast etc?

johannes

--=-Ny6s97a4RxuDIJ5NcKIM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCfZCAAoJEODzc/N7+Qma9L4QAM4KDGOhpOsnjsqzWrt91K6/
fgGifvBwRrTnPQ9R+zGmyrlzu8T+cndfobyk7DAqcarfmQoaX4dvarES0ZlLfLqA
cQW/ym0eOccd/y9Qdy+YVNMdniUd6KHNWLcUekhnJorpX6HtPPK7qq9pfe/sfl+d
M1FQ3qCcNCgLt/neh/4SL0iChVHHtWYeHWPRBu6rZeY6jczwF143n240bb/TN3x/
jD5CPK8s1IswKrg6FvBHFZHXO6B06g1VHkgmy7gUS59YkmHHV1jGU9oWsPCtoX7v
nfVvwRFqjFqsuPV62wvEzfPteYPqCFfrd3vvohIUCUVAlhXoQPLU/8+hyWzp1Rd3
N2ODt3E4POPJW0nLmohaqFy/QCdo8O23n6ZHkfMHQcR1Jif/GWbXyao9E4FokFlK
l8HPBSFJfMGHZDWDxJ9HmCr6ii73QhYC9gC0CIgGhOPa4GbK55r1OelM6d2za7rT
AeFZqJ7ONMckw0p+zOQCWf/EgCsW3lwp3i+xY1ulFksRXFpILRU/lMvOVxqCWTkl
9nNlVn8Xe73qgTbDRSHozQYfu7hwJ3yVX35N6+YOu4umuPo1sSlU6IauUevGOEM9
2mClkxYsXe467QSG4nRzlMF/Xq2EGrBH9MPxFpq+qnKjEB9ZU+dfS7jp4tLW/V31
bpUv4lQInZJH4OtfsCPO
=qywd
-----END PGP SIGNATURE-----

--=-Ny6s97a4RxuDIJ5NcKIM--

