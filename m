Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440AbYECP2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 11:28:09 -0400
Subject: Re: Please pull 'upstream' branch of rt2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Scott White <nwi_sub@hotmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200805031702.20416.IvDoorn@gmail.com> (sfid-20080503_165631_067313_B10C7019)
References: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl>
	 <200805031158.43072.IvDoorn@gmail.com> <1209809936.10921.9.camel@localhost>
	 <200805031702.20416.IvDoorn@gmail.com>
	 (sfid-20080503_165631_067313_B10C7019)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WSWD6SmJ0bBWdjpjoxqq"
Date: Sat, 03 May 2008 17:27:58 +0200
Message-Id: <1209828478.3673.2.camel@johannes.berg> (sfid-20080503_172743_344928_6E2BE581)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WSWD6SmJ0bBWdjpjoxqq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hmm, perhaps we need some way the driver can inform the rate selection
> module about statistics. I mean the hardware does measure the number
> of failed TX frames, and the number of retries, but it doesn't set them
> in the descriptor but in the hardware.

Yes we should have this.

johannes

--=-WSWD6SmJ0bBWdjpjoxqq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASByEfaVg1VMiehFYAQLIyg/8C7Cv6EynPz/oaRLPn4rXWD0sH82pO7TK
6va7L46a1Rc51VFfeJN8EJ4OFfa72gaMJJcrA1H6/8sEt+xfUQ/ILN0a5gsCKqO7
LH6fimheVpmYpKeElXzMS1QKzBdUqism82+U135F0aBns4eWgcxUfZ+bpeh4CqkQ
lcL7NqmjGowXJFECJpz7l4qOLDnGRTlQFGIRRgf4NKtfW3Y0gqMazD5aiI2ICQA+
zicyJpLusCMjfbeEH3tXHKore5zzJbLLPbsXdYguW984DaXC2VqZQBzu/YI/kVoG
+Zu0msjxZOagWv4D6ISnA5m8wmHrnsNcdyfNh0EH6lacyTWjIk+vM4TksnDnHcXN
b15JtG4hg4YDxTf/rb/iR73LC9G6PEY0g8V4oB42dcXW3gTFT8kAPlthR7lujasz
7265siKSnkCj+z/+3zcmnXBkFKzMbgenm778tIZL2G8tcymTXgIh0p5M3yqLpP/i
J+IIoSAqYzz91ctmDwvBtUveAiHhXX3i0eBym1cAmGFLygx5SXCZ0D4QsUcuUdOm
6EDZ/jJumSTgssY14J+QopFhB3BlWKg0e8YnL/rMFqEZSl3Ls+q9DvVOqUzrwswM
x8qeI+CHOTlhDALF2I6DtskdEvM8FHYta4J+Kr2jeqxXxfpi6MXDFbA/+q25J2mA
8i76BFJ6NCU=
=SV2l
-----END PGP SIGNATURE-----

--=-WSWD6SmJ0bBWdjpjoxqq--

