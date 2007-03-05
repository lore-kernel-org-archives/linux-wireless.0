Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933471AbXCENXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 08:23:07 -0500
Subject: Re: Filtering in Monitor Mode (was Question about PRISM2  header rate field)
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <45EC18A9.50003@warmcat.com>
References: <45EA9E39.6080706@warmcat.com>
	 <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com>
	 <200703042210.52534.flamingice@sourmilk.net>
	 <1173094447.6131.56.camel@johannes.berg>  <45EC1454.4080605@warmcat.com>
	 <1173099910.6131.71.camel@johannes.berg>  <45EC18A9.50003@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-biacEMYky5rABGds64f/"
Date: Mon, 05 Mar 2007 14:22:37 +0100
Message-Id: <1173100957.6131.76.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-biacEMYky5rABGds64f/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-05 at 13:18 +0000, Andy Green wrote:

> Not sure I explained well enough: looking at libpcap sources, it=20
> compiles the filter you request into a bytecode and then gives it to the=20
> kernelside using an ioctl.  When you recv() or select() on the monitor=20
> interface after that, you block until something matching your filter=20
> definition turns up.  Userspace doesn't hear about the rest of it.

Uh eh right, I'm confused :)

The power save mode argument still holds though, we might address that
with non-promisc monitor interfaces even though they do have a couple of
problems (you need to be associated on a different virtual netdev for it
to make sense...)

johannes

--=-biacEMYky5rABGds64f/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7Bmd/ETPhpq3jKURAs6IAJ9EsJIgokTFkHz5VEUIssS7q4woPACgkcJq
sxBQ8/v0hyHovODTIu8gVJ4=
=UvaG
-----END PGP SIGNATURE-----

--=-biacEMYky5rABGds64f/--

