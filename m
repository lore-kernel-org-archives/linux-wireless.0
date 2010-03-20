Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36698 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683Ab0CTP0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 11:26:23 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Cyril Brulebois <kibi@debian.org>, 574526@bugs.debian.org,
	Greg KH <greg@kroah.com>
In-Reply-To: <20100319084623.GA27646@dhcp-lab-161.englab.brq.redhat.com>
References: <20100318200535.5639.6476.reportbug@bowmore>
	 <1268961358.18314.43.camel@localhost>
	 <20100319084623.GA27646@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YZ1gIG89ZdyQAGHhKKK1"
Date: Sat, 20 Mar 2010 15:26:13 +0000
Message-ID: <1269098773.18314.49.camel@localhost>
Mime-Version: 1.0
Subject: Re: Bug#574526: linux-image-2.6.32-4-amd64: iwlagn flood in dmesg:
 free more than tfds_in_queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YZ1gIG89ZdyQAGHhKKK1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-03-19 at 09:46 +0100, Stanislaw Gruszka wrote:
> On Fri, Mar 19, 2010 at 01:15:58AM +0000, Ben Hutchings wrote:
[...]
> > Stanislaw, do you understand how this is going wrong?  Do you have a
> > fix?
> >=20
>=20
> It's here: https://patchwork.kernel.org/patch/86722/
>=20
> I'm really sorry that make this bug during backport to .32.

Thanks, I will apply this to the Debian kernel.

Ben.

--=20
Ben Hutchings
Power corrupts.  Absolute power is kind of neat.
                           - John Lehman, Secretary of the US Navy 1981-198=
7

--=-YZ1gIG89ZdyQAGHhKKK1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6TpEOe/yOyVhhEJAQKV7w/9Gneu5ImwnGBL8lFLe+S5GJY3W9IObpon
uruoDZgHvGa+mP5lHUSVwES1oNNnCmEwJu7vAnxWggWhhXQXTqkoicRFEnXN4KXH
VrpX36lq6MXgN9QD4zBkSUi6NB/dOJdLJxSnFuVOIG1ctWuzfC+smoxbwo0otjyv
+ep2KpJgSDh06R7nb3Nssk1jusMyEcKQdgakfvOAG+Sb4L2DmwfE+PSdc9jk05KW
IvZMyO3AlotVwtjKPoxvrrXFDK+NaztDf3uUkmQL5ADlNk1oHIVhqF60klOYcsNd
m1ySOGBWI2Fv5y470nLS6UihdQ69Yh7KuC4N2cdbT9ZgfUaZHIcil7Hm3DEBv+/9
Ws5P1uCaVvTgf11eF9YK8OPSxtYhuBIGE7NkT2HAt9mb2iLc1Z+9lS5vahVAFiki
MfY9zr8OvPbwxah0s8jxEXZYqi1Sue0yar9oCer6f3Pe141CpIORgHeFMTfkIvwI
OBAol3KKjag0hFhq578rk5i8LYdBeIaLfdONu0vrnvotVIy4P0mJ3zehrkm7RcRm
3a39ecqR9IwzTyJ/RX+mmB9ViDuw04tmMdg4O6lVmxgLhb+6tJRF4dh/0rAGOi+B
kUR5+X+ovw3m9290XPXHwFsgIoVVPiPur419TliWlH4FSZ6AwVGWfqRozhXvKsr7
8K/7FzflJMM=
=d0x+
-----END PGP SIGNATURE-----

--=-YZ1gIG89ZdyQAGHhKKK1--
