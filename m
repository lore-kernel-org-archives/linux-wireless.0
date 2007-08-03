Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbXHCWYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 18:24:21 -0400
Received: from [84.135.224.6] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IH5ZD-0006z4-AZ
	for linux-wireless@vger.kernel.org; Fri, 03 Aug 2007 23:24:20 +0100
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1186178959.13315.30.camel@johannes.berg>
References: <1186178959.13315.30.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F42VcEmvxK+B/YZ8BJcj"
Date: Sat, 04 Aug 2007 00:25:54 +0200
Message-Id: <1186179954.20275.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F42VcEmvxK+B/YZ8BJcj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-04 at 00:09 +0200, Johannes Berg wrote:

> After some discussion and review of Daniel's document (thanks!) we came
> up with the following ideas:

Of course, this also means that drivers now get to keep track of any
added interfaces to program/unprogram the MAC address.

On the other hand, with these changed semantics open/close could make
more sense again since drivers now need not always count interfaces and
monitor interfaces are no longer added/removed to the driver; hence the
open/close callbacks could be used by drivers that allow only one
operating interface at a time.

johannes

--=-F42VcEmvxK+B/YZ8BJcj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs6ty/ETPhpq3jKURAnPPAKCFlaySfUsYb2P/+JbHiiZfSHm5+QCffZun
f3oDO/HShKwbfTYOykfEwG4=
=OsoR
-----END PGP SIGNATURE-----

--=-F42VcEmvxK+B/YZ8BJcj--

