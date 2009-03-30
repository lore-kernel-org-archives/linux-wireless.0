Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZC3PT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 11:19:27 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20090330132911.GC11934@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <1238406057.24972.23.camel@johannes.local>
	 <20090330132911.GC11934@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9xWr+rv3U9V7XTET/xvM"
Date: Mon, 30 Mar 2009 16:08:34 +0200
Message-Id: <1238422114.5970.6.camel@johannes.local> (sfid-20090330_171931_245402_9C22B9CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9xWr+rv3U9V7XTET/xvM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 10:29 -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 30 Mar 2009, Johannes Berg wrote:
> >  * thinkpad_acpi.c
> >    -> need help, convoluted code I don't understand at all, looks like
> >       another candidate for rewriting
>=20
> Heh.  I will take care of it, obviously.   As for rewriting, well, a clea=
nup
> is in the queue.

Heh, thanks. I appreciate any help even if the golden rule still is that
those who change the API get to fix users :)

Thinkpad in particular confuses me due to the way it uses force_state
and input. Is it like Dell in that the button press causes a soft block?

johannes

--=-9xWr+rv3U9V7XTET/xvM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0NJeAAoJEKVg1VMiehFY7HIP/R0aeqPjclHVMIHya7TZAJgB
eJ+LNAHpTYud4qQugWif3hHAaSj2uQii1e+1AgUOxXdL0jXygN2pokAWUU+yEwCa
WYP2RMebjkLV22Nf4y/YODA6Dwa/vlzV+s0ZjR/ju2fH2DjP10UfilRZ+WxXifbU
L6gPSrSzDM9HLPF7kHB00LZCSEEU3GbAVqOxyyeGThuNZKYuIqrNpy06e27kSh+b
LDuTwLXLV8X8+xzoWkF0+OMXMXvxMyOuDg325kPnj0IGhLr4OnbF8jRSt1T0zTEq
hncXEg0LElwufOYJGZtKa4sgoXEToxxi4wHEQS5+VVEqAdLgHkKNVPV1eWjreNYv
Ka3j+x4KOWHtllKPraLb2ZXo5AtqXeH94NIjrGVaHYT7jys6XXeYTXqmWCvL2VLb
XNAOPs2Gn+QoGnStCiWIhYnA3LbMY6h19046Z/B0ESJyEaTUMzwfGLgX4nd2MMeq
n7vKETUY0DH7UNu+89xUZXt9vGKrir+V6fUVh6d3io0DeLPwB9mCL9X9PDkR/UlJ
sDae5c01Cf3myZIdzDSW0MgAT8RLa5VScvcqwrYYAlXrVuWzgNxDWfpbXrnqiL4/
U5gFN3XoYtOLUqmwXHnfGs0xxK8tinHaqEPohhnnxREWee5nPrQsLNcKDEQrqvGY
9nTfYUj4RhCwHhcoXN67
=3+Ii
-----END PGP SIGNATURE-----

--=-9xWr+rv3U9V7XTET/xvM--

