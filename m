Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZFQJhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 05:37:24 -0400
Subject: Re: Proposal enquiry for Wireless Roaming feature enhancement
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Balaji Ravindran <b@w1an.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mircea Gherzan <mgherzan@gmail.com>
In-Reply-To: <87hbyfmlds.fsf@litku.valot.fi>
References: <4A38672F.9090904@w1an.in>  <87hbyfmlds.fsf@litku.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LnMeGNVP1/K2FkCv8X/A"
Date: Wed, 17 Jun 2009 11:36:51 +0200
Message-Id: <1245231411.20613.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LnMeGNVP1/K2FkCv8X/A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-17 at 09:20 +0300, Kalle Valo wrote:
> Balaji Ravindran <b@w1an.in> writes:
>=20
> > Is anyone working on this feature enhancement(i mean wireless roaming)?
> > I saw it on the to-do list, and that Mircea had proposed it for GSoC. I
> > thought i shall dig into it, but just wanted to know if anyone's
> > already  being involved  and actively working  on it.
>=20
> Nobody is currently working on it AFAIK. We are planning to talk about
> roaming at Berlin next week and I will have a brief overview to start
> the dicussion, but that's about it.

Yeah, I don't think anybody is working on it. FWIW, what we need in the
kernel/drivers is, I think
 1) signals for significant signal change (offloaded to firmware for
    beacons while no traffic is flowing)
 2) a way of telling userspace whether or not it has to handle roaming,
    now that new cards are showing up (iwm) that can handle it
    themselves

and probably some more. I don't suppose you will be in Berlin, but it
would probably be helpful for you to wait for that discussion to have
taken place before working on it, because then we'll have at least a
plan of where we want to see this go.

johannes

--=-LnMeGNVP1/K2FkCv8X/A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOLksAAoJEODzc/N7+Qma4kAQAIJ2jBz48LmV4YLps4rrcoxx
p53Vdbxc6I46dfOJMLTUXNAgrYkkH7DExqj2+4tE975ZtNSS6jUeDHd0TzZScoKP
4oNVE3diRsOQiHh9bOL9Exyb3GB/Rkz/6WIbAMZAGfzxqNjoyV3rCbvdWclX6V31
k25I6jWpaLlNCWfWzugXuvTqKGd51FZzjujp7fJ9MZ5z9HVlVm385ZL8bdKggTKX
hTjbNUpl8ssuyq/AusQmfBi8BwldBpWI8pKEwf3RzpXuV2y8KrJSqI4bxFbyEBoB
EfIM1EVkkJOKTmAsDzmdJdE1fWSeJ32NPJkWzoed3fWOZzBOto2972nIfqtj2AiT
5BEbV2ju5LshX3Vv2wqHXzIJhZand5bGXjARQlMIHIVutul+5FLN7LYESJ/nceUv
D7tOT1F5FJEyTKqhw+rUSQxr/pqbQrMekmWnopMDzTXe9LkJvoUyuE2v1UInm5Il
ld6VZjrZJAVTMrJkEzmEG4GVzFi8QdkNmeI/lINKzN0kj6mQ14/7gfxB9YLbjY9i
uUiRceVOX/RFwuMnF2Sq48WY+cgCCL4TRwXH1elW9ooYnr3mISHR74BV3RJxyck/
W+M1vLrvNNbk23HWs/7MxCxvI+mKoVQsslDRID3WXoTAYuWiouHM2JsdDEMaOjbU
+kSFJN2aWll+wjar0fi4
=z/b5
-----END PGP SIGNATURE-----

--=-LnMeGNVP1/K2FkCv8X/A--

