Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZCZINX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 04:13:23 -0400
Subject: Re: p54spi - mesh mode summary
From: Johannes Berg <johannes@sipsolutions.net>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200903260922.48489.jcmvbkbc@gmail.com> (sfid-20090326_073111_119238_390C7128)
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com>
	 <200903251442.58712.chunkeey@web.de> <200903251534.29549.chunkeey@web.de>
	 <200903260922.48489.jcmvbkbc@gmail.com>
	 (sfid-20090326_073111_119238_390C7128)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-s+RfOfn1Kli4Z5Ko4reS"
Date: Thu, 26 Mar 2009 09:12:47 +0100
Message-Id: <1238055167.4331.3.camel@johannes.local> (sfid-20090326_091327_686389_4179F11E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s+RfOfn1Kli4Z5Ko4reS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-26 at 09:22 +0300, Max Filippov wrote:

> 3) Beaconing works, but not the way it should: like MPs don't hear each o=
ther. Timestamps never get in sync
> and both MPs issue beacon during 0.1s beacon interval.

That's perfectly fine for mesh. You're thinking of IBSS.

> 4) Pings don't go, because MPs don't answer ARP requests sent to it. Have=
n't tested for the root cause yet.

Maybe some multicast issue?

> Are there other sources of information regarding LMAC interaction except
> http://wireless.kernel.org/en/developers/Documentation/specs?action=3DAtt=
achFile&do=3Dget&target=3DSTSW45x0C_LMAC_API_ED1P4.pdf ?

No; well, the header file.

> Who should be contacted with questions about firmware behavior?

I don't think we have any contact.

johannes

--=-s+RfOfn1Kli4Z5Ko4reS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyzj9AAoJEKVg1VMiehFYXHsP/34LsCczNYhhLc/ZBaE8LyCv
ZGR09B92kOyUVCM6dOgB0MQ4iVaw9fd+Nc9H5LYiOVRBIl7mnaod+HGcwoOI16va
mbsxezkoW8GEQ1x50gqW7vYNw+Ku1X94S1542eOefivOSaO9ZTqVsIUTHnC4Vl8z
eq61c6zwv6HjG8jdwTEsJnwyn0nHcknmV/n86NWdkbgzAwSq4dFXsaRb+BhKjdrR
uUuQUG9TyzaEkeDFUnAPU2FFaRq702GOCcQu3U7XIGUlVGoZQ8XD8iZahCIjL6ch
7udX87mbp1pGrnJAaYJgF2ZLFs3stobRVDz40G9cpuBExrDSpNORHt8p6NkSAdRw
arHdE5H0ffAmo+VnDBjO3Zf3+gHDBnoA+o57jvj3NPLMgfyGf1/h8epufh29uPrq
GuWrD4kkBjOGsPtTf+QlC6iO+2R2SzYbEP274Y7unnCa73bLE+GU/yBjULFrI0BR
rZ0sj2vRO5mbPD2xOwvixERCfoAcEr0oQwh4AY/5V26NZ1A0jasJ14M6JgbRQRT2
Zdjxu4RLd8e/qUylWaPWMtUb6Tf5UkChgiIVziFfZHtkbpP7uikiRHZcKjyhyqxi
iUXsVN/1kQBhUk2GE0MELjNFXnzajxS0Srcuddbw7FLSUYU7JEcCbWx+0Z5nbTQi
NXuLv/3q5VTnCi4vAIFD
=SDZm
-----END PGP SIGNATURE-----

--=-s+RfOfn1Kli4Z5Ko4reS--

