Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbXEJRD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 13:03:56 -0400
Subject: Re: support for bridging ethernet and 802.11
From: Johannes Berg <johannes@sipsolutions.net>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CCA1D7C0-D44A-450D-A76E-DAE792E0CB37@kernel.crashing.org>
References: <CCA1D7C0-D44A-450D-A76E-DAE792E0CB37@kernel.crashing.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/+vkCqKKoBzGwJSRtpku"
Date: Thu, 10 May 2007 19:06:21 +0200
Message-Id: <1178816781.3806.31.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/+vkCqKKoBzGwJSRtpku
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[adding linux-wireless]

On Thu, 2007-05-10 at 11:18 -0500, Kumar Gala wrote:
> I'm wondering how to tell if a given driver/device in the kernel =20
> supports the ability to bridge between ethernet and 802.11.  From =20
> searching the web it looks like only the prism driver/device supports =20
> this.

Normally wireless drivers do 802.3 framing as the 802.11 standard more
or less requires, so it should "just work". Am I missing something?

johannes

--=-/+vkCqKKoBzGwJSRtpku
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGQ1EN/ETPhpq3jKURAtqGAJ9iAYgHtJeWKEiPsz/7F5gpHpqlhQCdEtLp
E6ksXe33JxxG+rne2UzRPiI=
=oCG2
-----END PGP SIGNATURE-----

--=-/+vkCqKKoBzGwJSRtpku--

