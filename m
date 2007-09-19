Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbXISKWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 06:22:35 -0400
Subject: Re: Fw: build #301 failed for 2.6.23-rc6-g0d4cbb5 in   linux/drivers/net/wireless/libertas/
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
In-Reply-To: <1190170559.30482.14.camel@xo-3E-67-34.localdomain>
References: <20070915020251.2b5b8adc.akpm@linux-foundation.org>
	 <1189847359.23521.2.camel@johannes.berg>
	 <1189954364.29570.15.camel@xo-3E-67-34.localdomain>
	 <1190170559.30482.14.camel@xo-3E-67-34.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-71HrAPlWFMblH/Qblhm1"
Date: Wed, 19 Sep 2007 12:23:53 +0200
Message-Id: <1190197433.4414.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-71HrAPlWFMblH/Qblhm1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-18 at 22:55 -0400, Dan Williams wrote:

> Any ideas here?
>=20
> Every single one of these reputedly undefined symbols is currently
> marked with EXPORT_SYMBOL_GPL in 2.6.23-rc6.  Is that not relevant to
> this issue?  If not, does building libertas into the kernel preclude
> building stuff that depends on it as modules?

Fun. Toralf, which kernel were you building?

johannes

--=-71HrAPlWFMblH/Qblhm1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8Pi5/ETPhpq3jKURAqU4AKC004BDdkndGCOF3H45DTfaS1nsbQCghbkD
juMJme/RzGdC5cyqyfUwGKM=
=ULey
-----END PGP SIGNATURE-----

--=-71HrAPlWFMblH/Qblhm1--

