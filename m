Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYHBTRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 15:17:39 -0400
Subject: Re: wireless USB adapters recommendations?
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <g72be3$gpf$1@ger.gmane.org> (sfid-20080802_211017_111832_D6ADD2A8)
References: <4894AC77.5060801@wpkg.org>  <g72be3$gpf$1@ger.gmane.org>
	 (sfid-20080802_211017_111832_D6ADD2A8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Fk5gh4B454YyH5aorlP7"
Date: Sat, 02 Aug 2008 21:17:33 +0200
Message-Id: <1217704653.8621.54.camel@johannes.berg> (sfid-20080802_211742_513280_9258A5B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Fk5gh4B454YyH5aorlP7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-08-02 at 19:09 +0000, Daniel Gimpelevich wrote:

> > I'm looking for a USB wireless adapter which is well supported under
> > Linux.

> > - WPA2
> > - should support ad-hoc and access point modes - should work under
> > mipsel (I had once a prism54 mini-PCI card which didn't work under
> > mipsel)

Didn't work under mipsel seems fixable, should be a driver issue.

> Your requirements are mutually exclusive at the moment. Here is what the=20
> FSF says on the matter:
> http://www.fsf.org/resources/hw/net/wireless/cards.html

I wouldn't be too sure the FSF is a good source of information regarding
wireless on Linux (or of anything about Linux for that matter). And the
list is, indeed, rather incomplete and gives a very skewed picture.

On the other hand, I don't think there are any USB devices that support
AP mode.

> Access-point mode is now dependent upon nl80211, which isn't finished yet=
.

Patience. It will be soon.

johannes

--=-Fk5gh4B454YyH5aorlP7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlLLKAAoJEKVg1VMiehFYoCsQAL7jtymoXZnSPZKA0XunTaLI
QhJcxTu0G6W3QQK6PpinXiOCE/q+9oqXW1nx9XSw68JvweOsSk+GmQEiOvIPIbOi
Un91eVfh04p4j2pRxj4LCTbL5SUS3yTiYhQNzZC8AjQ/8DPPT/J3EtZ2hhDJqi3R
I4A7kmqfsuZw/jN0BqnRBP1iyaZfRFQEd783GdfWchIR0Zuua5UMH1yMyycRYVkR
mcHZr1YGLKIVG2BYKrL/Axg8UVqhA7TXn+kO0wHeuQzQG78l2hmzsoBmI4+J9HdR
phyRNmav190Ski6LNc+Anc5nXQDRgy7tr6tqPD3AuWjchE6I05OPOreCDOxyxDY2
3WDRnZJG2lhz670y8mh+UbuDv0jZ9PmIlpJX1jtfk94QjhUF/mA/FD7PcpfvGz2i
RlNyTXvmQCeU8Yc5o2AgrFXi2CU5vNaOO4DCGmle8t5wf7A0Rx2VBRiT5MCSMCTs
e5cVVYpXV8fhO08GwzS19SoBqwTg3MAU088p1JjCrtdU90sLStgwS4uOoFu/tvZq
a/uTVVybUpRSBweBV/2JcVI7/ygMblG0m9TSYq6ie85I825aPW9ubGhnXI2NLwv3
iZX/vsBCI17vxTI+D35cs95au1M81jUYT6Me+WPt4fbHd9GIWYSDCox5s1Rrztyd
MtzfLQc1pp6zZs/X9f7A
=6nUP
-----END PGP SIGNATURE-----

--=-Fk5gh4B454YyH5aorlP7--

