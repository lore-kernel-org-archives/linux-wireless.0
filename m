Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbXEMIWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2007 04:22:52 -0400
Subject: Re: [PATCH 1/2] Add 93cx6 eeprom library
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200705131013.15985.IvDoorn@gmail.com>
References: <200705111559.41153.flamingice@sourmilk.net>
	 <20070512191749.GA6018@tuxdriver.com>
	 <200705131013.15985.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZkRpsARFGJUph9NfZas4"
Date: Sun, 13 May 2007 10:22:54 +0200
Message-Id: <1179044574.2647.26.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZkRpsARFGJUph9NfZas4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-05-13 at 10:13 +0200, Ivo van Doorn wrote:

> > > +}
> > > +EXPORT_SYMBOL_GPL(eeprom_93cx6_multiread);
> > > +
> >=20
> > It's pedantic, but I hate empty lines at the end of files...
>=20
> GCC usually complains when a file does not have a empty line
> at the end of the file.

Nah, it only complains when the file ends with a character other than
'\n', i.e. the last line has contents. This would be represented as

+EXPORT_SYMBOL_GPL(eeprom_93cx6_multiread);
+\ No newline at end of file

in a unified diff, where that "\ No newline at end of file" text is not
part of the hunk (that is, the hunk linecount doesn't include it)

:)

johannes

--=-ZkRpsARFGJUph9NfZas4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGRsrd/ETPhpq3jKURAoc4AJwNmxjo1CwW1u7K6bSXPUoTdLNbJgCgiGBH
iW4FJ8YgX/cwvdUPPPU2EfU=
=fLT9
-----END PGP SIGNATURE-----

--=-ZkRpsARFGJUph9NfZas4--

