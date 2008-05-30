Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYE3Pm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 11:42:56 -0400
Subject: Re: suspend vs. b43
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200805301720.49327.rjw@sisk.pl>
References: <1212150713.4117.2.camel@johannes.berg>
	 <200805301642.05248.mb@bu3sch.de> <1212158782.4117.8.camel@johannes.berg>
	 <200805301720.49327.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-slu+M5or56LLaZ8+Nzqh"
Date: Fri, 30 May 2008 17:42:43 +0200
Message-Id: <1212162163.7238.1.camel@johannes.berg> (sfid-20080530_174302_554718_6B34FE07)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-slu+M5or56LLaZ8+Nzqh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-30 at 17:20 +0200, Rafael J. Wysocki wrote:
> On Friday, 30 of May 2008, Johannes Berg wrote:
> > On Fri, 2008-05-30 at 16:42 +0200, Michael Buesch wrote:
> > > On Friday 30 May 2008 16:37:18 Johannes Berg wrote:
> > > > Odd. Resume itself works just fine here, except when b43 is up. But=
 then
> > > > again, you might not notice that this is the problem because by def=
ault,
> > > > nothing gets printed on the resume console and then it will indeed =
hang
> > > > with a black screen.
> > >=20
> > > How can I change the printing?
> >=20
> > Hmm. It seems I might have been wrong here. Rafael, do we still have
> > console suspend stuff?
>=20
> Yes, we do.  Use "no_console_suspend" in the kernel command line to chang=
e
> that, but note that it's not generally safe (eg. if you are using netcons=
ole at
> the same time).

I see. System reset hard and clock set to 1904, PMU didn't like me :)

Thing is, I do have no_console_suspend (hardcoded in my boot loader
config so I forgot), but even with PM-debug I didn't see it hang at b43
and no useful messages. Not sure what to do, hence asking if anybody has
the rtc-trace stuff.

johannes

--=-slu+M5or56LLaZ8+Nzqh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEAgcqVg1VMiehFYAQJsHA//UEznBUP+0VpsS+bgthD22P0senxcLEut
TZQwIDgbxCqIBuUR+ebNFlSdvCg9N5OKWZKcrYvP8pGyaIDBfGJcIs3/09L1N/on
85tdTNSTNMxYarArtmL8mTOqK3T9FVsGg42HNfEIwieXvVSvVJLmK5byRjG8CSLO
6esRQ2dU9jj/Lsdjq4TtqEA/mOQd9zKcQpDEMgZIgwPFrvESqdqXfljLxskjoE7A
tiAUt+cEh8PrkANeK5AT9S+j82Si+zI8BfINbrZbWE1E8tHMr4u4ei3nRqGESpgJ
cQ4sK1zZZyYKjKLGc2AifeaKJKiUr+iv1yW8ZfeJkzrU0KuyedNg3JwxpHSgtH+U
NX49rokaSMPxxolwD0EF/35c3asQ/HvwCxbcXWhkVJbF3ZsUSGjHIjLpyDz62QFR
DRo3SgPcw0PX2BlZYWkwKS5x2D9Txhmf/NPDu6uE+ZcPypGxsU+y6+Av6EKoxxsX
CPuWa2M4Ln9Nj7FSqbk/eiRdmjQZYwsOeg7DaoH7VfNvBwR6eZkmnMh7lZ76MgTh
AjFJwevSh/7o2I6jTNX1QFN8RLFDfuAECVAZ0nuS0RkWPZqAjp2rlNLMBkvcTT5B
pPyAAwAJhFn6Y3NF7e3ANumPXiyR0Ba/m8HNSyH+LhGBaN2AQFMx2McZVideljLy
4jXWPZ8zpyc=
=WuGQ
-----END PGP SIGNATURE-----

--=-slu+M5or56LLaZ8+Nzqh--

