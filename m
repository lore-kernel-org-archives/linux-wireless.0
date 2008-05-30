Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYE3Ou2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:50:28 -0400
Subject: Re: suspend vs. b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	bcm43xx-dev@lists.berlios.de
In-Reply-To: <200805301649.14445.hs4233@mail.mn-solutions.de>
References: <1212150713.4117.2.camel@johannes.berg>
	 <200805301606.25556.mb@bu3sch.de> <1212158238.4117.4.camel@johannes.berg>
	 <200805301649.14445.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xJuv+xM5rTS/fqqwf4eG"
Date: Fri, 30 May 2008 16:50:03 +0200
Message-Id: <1212159003.4117.10.camel@johannes.berg> (sfid-20080530_165030_358309_31FB6AA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xJuv+xM5rTS/fqqwf4eG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-30 at 16:49 +0200, Holger Schurig wrote:
> > Odd. Resume itself works just fine here, except when b43 is
> > up. But then again, you might not notice that this is the
> > problem because by default, nothing gets printed on the resume
> > console and then it will indeed hang with a black screen.
>=20
> pepper it with printk's and add netconsole ...

Well, yeah, netconsole _might_ work as sungem gets resumed before b43,
but I tried doing that on the regular console and didn't see anything
useful.

johannes

--=-xJuv+xM5rTS/fqqwf4eG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEAUGaVg1VMiehFYAQKL2A/+ISdvs73qXlX7w/qRYzcKFYdhwFNFvwXx
RyGtygpBHe0VbDahHygEfhABIw50BvTDEl27yHs+iqaysNK3XZ2Y9aWMynsuf82H
IhLn/qyk6fkmrzv2A4yLAa20kx772+PGb47Xmzh7wuxah4MWPT8fMEeSWbJLnw6I
uS2G7b48GacLqfkAziN96noZ7cBJfcPuGO9PNHAvOE9Wnu9sr+4M51wA2JEmAk6Z
yK9OqXYFukblf+V5eKpttCccr4duQcVA5p7b5ZSAfvooOntVTXQvGpy0MXQHCent
6HIEARLTR6AJzwL+Xoq9bDp1jign7MXaHqV5ZHUzY1w3luJJu69vW71fI7Rnsnvv
LFXmRv15C1bIrm+5COyejTwA5xy52abrbwyVOXTJkOiYGfg+HwYzSm5rmgj1QAIy
5+FlLYWLVTe18/v7IduWdrtFtxwWd5GOMoavhruVZ0Gzzh7w55Jmv/VHph5X5ZVz
jcATQhWDnlKfDOndE3On4DLCijmKVNGKExW136dPgR9jStVSGurlZ7poAQudeKf6
sJDgTWBQl4/dBsbdjU0u8ORF0OvFl/Z496h0562qmIS5gA16URqC16a1qWKJVRwP
tarnehvJmJENvtcL0PeAR8r+pFS20tV3vCagETR1TCqvvydYKtM80AxZp7hATgyM
VmzigF72stE=
=cox/
-----END PGP SIGNATURE-----

--=-xJuv+xM5rTS/fqqwf4eG--

