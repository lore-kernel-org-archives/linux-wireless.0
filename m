Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYKAPe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 11:34:58 -0400
Subject: Re: crash with rt61pci when resuming with card ejected
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200811011625.18745.IvDoorn@gmail.com> (sfid-20081101_162523_291419_CE20C07B)
References: <1225361553.3690.3.camel@johannes.berg>
	 <200811011129.25387.IvDoorn@gmail.com>
	 <1225541114.3619.2.camel@johannes.berg>
	 <200811011625.18745.IvDoorn@gmail.com>
	 (sfid-20081101_162523_291419_CE20C07B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+5P8e6XtXlpAzCrHhJfX"
Date: Sat, 01 Nov 2008 16:34:55 +0100
Message-Id: <1225553696.3619.11.camel@johannes.berg> (sfid-20081101_163535_468595_EC02A498)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+5P8e6XtXlpAzCrHhJfX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 16:25 +0100, Ivo van Doorn wrote:
> On Saturday 01 November 2008, Johannes Berg wrote:
> > On Sat, 2008-11-01 at 11:29 +0100, Ivo van Doorn wrote:
> > > On Saturday 01 November 2008, Johannes Berg wrote:
> > > > On Sat, 2008-11-01 at 09:58 +0100, Ivo van Doorn wrote:
> > > >=20
> > > > > Could you try this patch? It doesn't matter if it is on top or as=
 a replacement
> > > > > of my previous patch.
> > > > >=20
> > > > > This patch should also fix suspend/resume handling in general, I =
suddenly realized
> > > > > there was quite a big bug in there regarding EEPROM/CSR handling.=
=20
> > > >=20
> > > > Now it just hangs at resume, rather than crashing. At suspend it al=
ready
> > > > logs some MCU errors though.
> > >=20
> > > Hmm that is strange, those MCU errors could only come from right befo=
re the code I
> > > just changed. :S
> > >=20
> > > In any case, could you revert the previous patches and try this. This=
 is the same LED patch
> > > as before, but I have added the check for set_key() to return immedia=
tely when this is called
> > > while the module is busy unloading.
> >=20
> > Now I've upgraded wireless-testing and am running into the BUG_ON you
> > added for antenna diversity...
>=20
> Hmm, that's odd.. I'll look into it. Patches could take some time :(

That was with that patch applied, but I don't think it caused it. No
worries, I don't usually actually use the rt61 card, but had used it for
monitoring the night before I wrote my bug report, suspended, and
ejected it while suspended the next morning because I had to run... :)

johannes

--=-+5P8e6XtXlpAzCrHhJfX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDHcbAAoJEKVg1VMiehFYuboP/15M+arLxLsAL/IbrZGWxyRG
YqkUe6S9jDgp3x6q0Y+MRRYs7nFj8XxfeQIqNBomhtHBkd9NzLm1YW1K7Eu99g1A
7wJDwkEtKfNuuikjSc83E8iesUDsG90eno9v9/LR1l1zBQjZ1OEUFFxrZg9zZhS4
g2z/vy07+/B55F0CSGWooG47uhVK/0uCSHhaWPs5Zq0jLpGyd4XQdNu9JtZcpC+v
jYR/5W6QYsUbUjzpA4C1CUOPAxquaTehE/BATNMGjvjtbKa4HW4KskMnpwzFf7Lm
S08PoXvhllv3RnB37eBS6mpDHOszCKABnofo8P50dCMgTOsPKdptLhuQO/61pJfH
8MPjeFQJGxLi6+bZHHlPxje8GmCvPRQ6w8+ErPj9xXGNrxA7h4gA381MIWagu2Of
xMq+OWVjYiaclI0lUvl8BIPOO/95Pcl+2euXuuA9AdA9qqnVhvDrV0CVHbVXG4IX
kCvExr65opRyku5J3TXhVvmiW80UrqrWwM0O60q5zRg2CDSfb36eyg8bqN88iE/a
28+i8d3JBUxA1JNrHChWcizcgP++KzvtPb3MdfRLuRapovjhYzXVOZqp0cmywotr
tMU5TTFw/R+swMmFeFctUc6u10yJKeXGNLTvBR/gUYtz95t7jqBA0kjf1RTqRU4H
xZhNGXNxgWB9ZgrRU+8a
=9jn9
-----END PGP SIGNATURE-----

--=-+5P8e6XtXlpAzCrHhJfX--

