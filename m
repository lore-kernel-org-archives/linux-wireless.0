Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43723 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbXJJIoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 04:44:12 -0400
Subject: Re: [PATCH 4/6] ath5k: Add proper support for multicast
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
In-Reply-To: <20071006011949.GD25022@pogo> (sfid-20071006_022834_266423_6E3EC072)
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo>
	 <20071006011837.GB25022@pogo> <20071006011923.GC25022@pogo>
	 <20071006011949.GD25022@pogo> (sfid-20071006_022834_266423_6E3EC072)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gAPPr/vSKfx/NuPvcJ3E"
Date: Tue, 09 Oct 2007 22:01:23 +0200
Message-Id: <1191960084.4013.54.camel@johannes.berg> (sfid-20071010_094419_255178_9022A928)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gAPPr/vSKfx/NuPvcJ3E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-05 at 21:19 -0400, Luis R. Rodriguez wrote:

> +	/* FIF_CONTROL doc says that if FIF_PROMISC_IN_BSS is not=20
> +	 * set we should only pass on control frames for this=20
> +	 * station. This needs testing. I believe right now this=20
> +	 * enables *all* control frames */

Which is fine too, but not most efficient. Remember that the docs also
say you can pass up more frames, so an implementation that passes up
*all* frames at all times is correct in that it supports all filter
flags; it is, however, rather inefficient.

johannes

--=-gAPPr/vSKfx/NuPvcJ3E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwveEqVg1VMiehFYAQJBLw//bsSGeVT5DfGiV2KhNKYypD1NBMkkjQhV
nuHJYkV/IVFFuwlikvf1B5BLtDRB3mzaZT+99zLvJ9/k7r8i0y5bfygRGsHSIzAN
mMlDQ7N4jRx5g6cevX+5wqCMeuNfR024dJjj4ZGEwLYuMpIRSpoJ55YaMFOLin2c
7+pK51aG92KmsSHisniDVInxTs+pXCpYzqzjGBMoiQwqvxRoPHabaWEwkF/pteua
ppd49hPGD55kZ9mNCd1n5cSDl1OUFoLdndng8b7qmYe95iMeRSZTZ4OzlrFlPAJW
QyRpE0G2aUo8N5crtV8loroRga717EvVl2TYydTgao0rzXgx6WX2Fgp3TnK/e7iK
egTssthucJAPMXf4S2kLpAnyouVt8Fzblmf8hSibQLhujB2wIYnKLIdCptr4mh2g
ueS2yAd/rPcxUi1Z+leLzCGJMRQ0GBtT4dlSPBS7pOHH7G5N7vkkSZjDbgyeqz6/
CgQ2zsjCpGTBbf+9gFfPct9MLtprFy8t+spPJl1ovy1iKcyFca1cmoYafBbBWqsb
rjFh7CpVaPY12Dascglgmhf38FKYcXpyzL0LVsnyIQQth28nOTBXxpK+RACxDUEA
uJRn9bjuUoq4seunk/e/2xzRPhFCHv8Qwz7+z1v5NwgB6tOciYI+3tkz0pyvehx+
VfhV0NTKpD4=
=5kEQ
-----END PGP SIGNATURE-----

--=-gAPPr/vSKfx/NuPvcJ3E--

