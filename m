Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYKAMFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 08:05:15 -0400
Subject: Re: crash with rt61pci when resuming with card ejected
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200811011129.25387.IvDoorn@gmail.com> (sfid-20081101_112930_904276_9189E4F2)
References: <1225361553.3690.3.camel@johannes.berg>
	 <200811010958.09194.IvDoorn@gmail.com>
	 <1225530913.3560.0.camel@johannes.berg>
	 <200811011129.25387.IvDoorn@gmail.com>
	 (sfid-20081101_112930_904276_9189E4F2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mlIVwnocDPOdtX5b9ltm"
Date: Sat, 01 Nov 2008 13:05:14 +0100
Message-Id: <1225541114.3619.2.camel@johannes.berg> (sfid-20081101_130520_689756_200C07E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mlIVwnocDPOdtX5b9ltm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 11:29 +0100, Ivo van Doorn wrote:
> On Saturday 01 November 2008, Johannes Berg wrote:
> > On Sat, 2008-11-01 at 09:58 +0100, Ivo van Doorn wrote:
> >=20
> > > Could you try this patch? It doesn't matter if it is on top or as a r=
eplacement
> > > of my previous patch.
> > >=20
> > > This patch should also fix suspend/resume handling in general, I sudd=
enly realized
> > > there was quite a big bug in there regarding EEPROM/CSR handling.=20
> >=20
> > Now it just hangs at resume, rather than crashing. At suspend it alread=
y
> > logs some MCU errors though.
>=20
> Hmm that is strange, those MCU errors could only come from right before t=
he code I
> just changed. :S
>=20
> In any case, could you revert the previous patches and try this. This is =
the same LED patch
> as before, but I have added the check for set_key() to return immediately=
 when this is called
> while the module is busy unloading.

Now I've upgraded wireless-testing and am running into the BUG_ON you
added for antenna diversity...

johannes

--=-mlIVwnocDPOdtX5b9ltm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDEX2AAoJEKVg1VMiehFYtyUP/RdMTYciNRgBq+w04/Jr4CC/
JPnzrvIhIkgEaee8n3r4teRycKQGduqoZDUPDIhIqyj31vyItYICiAS1u3H1e1v+
6BBkOrAjeULxWF8iV4EAe+D8/pmsQAINv6kzja9ZXGxAzFIIYfqbRlY9nIEcimql
9OCFrsNtYvwqOXzgXFAUfzNSlFYX0M+iwQYjm/jRthQuowzuwNcI99tlJDusfneO
dc5aG/RO9N6tG9s1YJYNXFNeWDa7Bvr+EgFIsn3Dk9MMu8u6qUqkFMqCQ8nPDZpH
cq8ZWK4REM4oENxDsj8qWMYu+lFGSJgOC1FZt6i9OQhlxZBOCElgRPszwm+DSd/N
pd8DL5NgxE67kUwtlAR6hDwJDcqzZpUuvmSyOyLzSosEYjOjCRGCVUqoF4rX242u
ArMqY8l++ksA0ax2xQBtoXw2ZCVewt9kqcQQaECdoAoHvAPSKeGjfIaTtJLlFLxt
voOfqmpB/Heqw7VZBsV9QkcuGOgBnnlXLnvOp0JH204NLDZ+G/qK4tkpKp13XYWA
EpA1wnpSkHr2tQVutmHdlCv1cWW4kcQb2iemXIZkn5cXsCnyat5c7rwP8KdKGOkC
nLWIgayjZ1cl3r5NP2N9IXojKyiO43p3I2QZa2f4sUHzaIzWE54wNZdKumJktKR5
WfrosQX8h4L1FDuaVTNg
=mK3K
-----END PGP SIGNATURE-----

--=-mlIVwnocDPOdtX5b9ltm--

