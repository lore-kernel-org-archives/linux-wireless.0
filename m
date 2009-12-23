Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZLWQZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 11:25:46 -0500
Subject: Re: [RFC/T] cfg80211: fix race between deauth and assoc response
From: Johannes Berg <johannes@sipsolutions.net>
To: Joseph Nahmias <joe@nahmias.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	562016-quiet@bugs.debian.org
In-Reply-To: <20091223162111.GA902@nahmias.net>
References: <1261481565.22748.40.camel@johannes.local>
	 <20091223162111.GA902@nahmias.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+mxr8xECTWJTD2imHkrK"
Date: Wed, 23 Dec 2009 17:25:23 +0100
Message-ID: <1261585523.7304.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+mxr8xECTWJTD2imHkrK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-23 at 16:21 +0000, Joseph Nahmias wrote:
> On Tue, Dec 22, 2009 at 12:32:45PM +0100, Johannes Berg wrote:
> > I don't suppose you have a way of reproducing this issue? I know
> this
> > patch will remove the warning, and I'm pretty sure it's correct too,
> but
> > I can't really test this scenario.
>=20
> Sorry, I've tried, but I cannot reproduce.

Ok. I'm pretty sure I understand the scenario anyway, and your patch was
part of a patchset I sent for merging today.

johannes

--=-+mxr8xECTWJTD2imHkrK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLMkRvAAoJEODzc/N7+QmaqgYQAL4+qhaSghEiyFy0uTqCF3e3
6vXMDxBqNh1maXxGeKL3BFBxl5vX8qamw/VNY6RvnMtzzZ3DhlRS+Hfj/FXbtUDu
8kGKFtX97XspXEuZaWLhLzFFD8qp100Kdoz1c6qPYfcJAQi36RD8AxDda83lhaR5
ykNoevhc2cq3xIjagmWnesMBBQOb99FTa0qv4bWm47z3jMx36FBgKo1x3BopE365
rAwd3HFtO2xZrPQriMRQcHyyqxQZ6Bc1p2+/Uy/tosuLDeHBNwVTOt+4zmp0p1MA
PgiDwzp7/DLSeuRa8420RSUMSTAFJYXwB9h97Wcv1zDxdbWJbAXEuTUvjZS2kup3
0GFLDgw7th/z3XbdoIBkkMYSvw3582PdhflqgIw+uXQ7Q6HB5OwB+DPOntjCV+in
W6R+vZN/FkjieiqUdlfyQ7qYByrEJAMXd/C82e85SGAuBG+madzM9YenY7sQy3gP
DhURKvA9vM4RsqU3Hwsj7HrBaMj2YwYBsDbxRgiRKP+r4lQgDZc2vpLBH+iJnsyF
WZ7vaCCw0SWTQRUaER6R5utOSgoS6tYFCg0CjnHGwc3QEQD0K5pGJfc8kFVJs1by
j64/Xgfe+7Iy1qpbGzWquVSYzY1RVa59kiwd51Q6UDpcebsOIs5rhiRtyFg1JdJN
1HRvZ6N9R7m+e36TG5sX
=BoyV
-----END PGP SIGNATURE-----

--=-+mxr8xECTWJTD2imHkrK--

