Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbXHTMSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 08:18:23 -0400
Subject: Re: Recent linux-wireless git changes have broken my prism54pci  card
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708201351.45575.chunkeey@web.de>
References: <46BFF10B.1090307@hhs.nl> <200708200244.22841.chunkeey@web.de>
	 <46C94844.3080505@hhs.nl>  <200708201351.45575.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tJmk/oq4Q2DYxxlHhpkW"
Date: Mon, 20 Aug 2007 14:17:36 +0200
Message-Id: <1187612256.6090.104.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tJmk/oq4Q2DYxxlHhpkW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 13:51 +0200, Chr wrote:

> "pyh2: not handling 0x02 type control frame" (could be the FW)

The driver, I assume.

> "wlan0: duplicate address detected!" (never seen this before... IPv6?)

Yes, IPv6, caused by the multicast bug.

> "wlan0: switched to short barker preamble" (nothing to be scared.)

Fairly new, but yeah, nothing to worry.

johannes

--=-tJmk/oq4Q2DYxxlHhpkW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyYZg/ETPhpq3jKURArvcAJ9oj9OveEbRz4ymIHOC+EdT4BT/7ACgrpxC
JVcDSCmikOgXbVG4T/4gl8E=
=RN/3
-----END PGP SIGNATURE-----

--=-tJmk/oq4Q2DYxxlHhpkW--

