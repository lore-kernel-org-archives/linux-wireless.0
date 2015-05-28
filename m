Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46363 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbbE1Meo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 08:34:44 -0400
Message-ID: <1432816470.6319.41.camel@decadent.org.uk> (sfid-20150528_143448_285651_5A249155)
Subject: Re: [PATCH] mac80211: fix kernel-doc comments in mac80211.h
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: andrey.konovalov@linaro.org, emmanuel.grumbach@intel.com,
	linux-wireless@vger.kernel.org
Date: Thu, 28 May 2015 13:34:30 +0100
In-Reply-To: <1432796432.2459.0.camel@sipsolutions.net>
References: <555a4e12.e323700a.26a6.ffff9e65@mx.google.com>
	 (sfid-20150518_223947_537367_CC6BC263) <1432127031.19214.9.camel@sipsolutions.net>
	 <1432769411.6319.36.camel@decadent.org.uk>
	 <1432796432.2459.0.camel@sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kndgpWM5AU8E4Dcn0ztY"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kndgpWM5AU8E4Dcn0ztY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-28 at 09:00 +0200, Johannes Berg wrote:
> On Thu, 2015-05-28 at 00:30 +0100, Ben Hutchings wrote:
> > On Wed, 2015-05-20 at 15:03 +0200, Johannes Berg wrote:
> > > On Mon, 2015-05-18 at 23:39 +0300, andrey.konovalov@linaro.org wrote:
> > > > Commits a818292 "mac80211: convert rssi_callback() to event_callbac=
k()"
> > > > and a940909 "mac80211: notify the driver about authentication statu=
s"
> > > > added two errors and one warning when building docs for the mac8021=
1
> > > > driver. Fix the kernel-doc comments so that the documentation targe=
ts
> > > > could be built successfully again.
> > >=20
> > > This was already fixed.
> >=20
> > It's been one week and this is still broken in Linus's tree.  There was
> > a fix for some of the other warnings, but I don't see these errors fixe=
d
> > anywhere.
>=20
> Yeah, somehow I put this into my -next pile... Given how late we are, I
> don't think I want to change that now though.

It's a build failure so it should go upstream now.

I ran into this while packaging Linux 4.1 for Debian, and had to debug
and fix it again, so that's now three people who have had to spend time
on this.

Ben.

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-kndgpWM5AU8E4Dcn0ztY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVWcLW+e/yOyVhhEJAQqDkg/7BVAr41O2apHeUJRMTKAudR2pYJ7rV9Eo
8xzhaGSg1WjRxJii/dan69R+RcfGRUmDlfxESWlyuc1El4NzZJs5X7E9fFmr/rbT
yg1diPyTk48iI3LhlAo8A3kZyi/eJVSE5yM0dGdw5VonD7+Ot4f/U3qxlkOrVzTc
NztFBnWYdlXbwbghMZDB1h0mL7zZKmE3HDokGwKSOj+Xu9ze1qFviqOvqUhwiewT
v2KBuM7g+TwiVAmoJRuTEW2RrKuNU3hW0QJ7lPoAk8J2gWlK4yzeP3+icsL5bRMg
twxD48gLzUbz6a2/htT4JQF8+OgErw6m1w8RO+rgD1MmxRGAFjaTK6q72J0laATZ
Q8Ef6FTpAN8uj5X4dX8QYhyIW+azMmXKK3Hiw3fq4ZXyVH6sN38L4Zxpe8DMa4Qg
rIQ/WCaUBWcAvFENBPEE3ED4Nw/dluQTscVkgbSsLIr7mhDmHX75JG5wNGRj/hMx
O79B9G6T1PcV+UfcNIW64Ss69r13MXFaCxg5Dc+pDNSjShnF8TiahTkRk9VmPK9u
JJAjUL9XsUZINCTREzYLf1Gf2KYlxPFj/RgPmIfs9uJmRrggKGbEyIPD+DHozIAi
5nitK9QTdRMmetZ2+5nBniU5hryepk964IjT0lGGnV4KkQa2gYliBmCzcXyrt/ZK
034uXrMf0I0=
=J/xf
-----END PGP SIGNATURE-----

--=-kndgpWM5AU8E4Dcn0ztY--
