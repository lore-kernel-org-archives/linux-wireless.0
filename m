Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbZGPTJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 15:09:35 -0400
Subject: Re: Cross compiling crda and SSL word size
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <9e4733910907161204x441c21b9n22530800682d363@mail.gmail.com>
References: <9e4733910907161204x441c21b9n22530800682d363@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DFudJdu5cq9eOMemSECn"
Date: Thu, 16 Jul 2009 21:09:04 +0200
Message-Id: <1247771344.30529.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DFudJdu5cq9eOMemSECn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 15:04 -0400, Jon Smirl wrote:
> When cross compiling crda the Makefile asks the python system what the
> word size is. This gets the word size from the host. Is there a way to
> ask the word size using gcc? In my environment the Makefile is
> automatically using the correct gcc cross compiler.

Can you just use gnutls instead? it has no such issue :)

Otherwise you can probably parse it out of "gcc -dumpspecs", but that
format doesn't look too nice, especially with multilib gcc...

johannes

--=-DFudJdu5cq9eOMemSECn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKX3rMAAoJEODzc/N7+QmazbgP+gLrXa/ZbcVQIicQuQbgBiR/
rvVMN2prdOjZ1lh9h85KuyDM3DYFtXVQJZSSRGOZRGFYhmapcZzU0zH4EcSrET4p
vXlYuTb/4KIP4chJKUC7hiqPQXkv9qIAlb8cLx8e7JmpjEXV0Cl+xATeXCxNfjYp
Heqaf1phtexextimPxNAlvWhIdfrZf+voIKLnSXqM52S2HNeRUsjJKJYkUlJO7SV
76oyciSIEiiX1ZNOxgrCDrVk9LLLY3Srs9oXEla9H3Jdwgj3OevjRIGSRTQk248m
MUGEOknEeFFVWsgciH4Fu4Kci04DUkQUL4uFs5+XAWp2HuhSrWTx4i2rLBDYXwbq
E2F7IRJINNkQUCd5PbGDMWOY0qzczqu4e7HgFnhUmU3e2u4MpDd7M/lDeh7lyE4J
f4elcsbO5LbOaUlJ7GXIi6SWt1upJj7rBIQdRZ1a5AhxFbUW2LOtxEnND9SwaHg9
OrLO2MqvVCsSk61WKxwmM2r8vDhecNkZRFeSr+OHYYrqcg6ACKj3hh+83zi3o7U1
OFi+y2Vgc1BddetxemxZcqYceNRb3zDRoEagXUocYrx6lUdABUbBuYvbYHr5EgQw
QOMBAjM/yUuMltmWNnu4ESZzs0ozEVSAG75AU2VCdnrfou5BSa+SOzEXubc/FEvN
JkscLANHMEXqrmmgoD5K
=r05G
-----END PGP SIGNATURE-----

--=-DFudJdu5cq9eOMemSECn--

