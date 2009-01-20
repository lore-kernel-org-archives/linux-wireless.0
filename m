Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironportin-vas-2.it.gu.se ([130.241.151.183]:17069 "EHLO
	ironportin-vas-2.it.gu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbZATJCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 04:02:11 -0500
Received: from pc5.socio.gu.se (130.241.119.5) by samfak1.gu.se with ESMTP
 (Eudora Internet Mail Server 3.2.6) for <linux-wireless@vger.kernel.org>;
 Tue, 20 Jan 2009 09:52:18 +0100
Received: from hans by pc5.socio.gu.se with local (Exim 4.69)
	(envelope-from <hans.ekbrand@sociology.gu.se>)
	id 1LPCLI-0005xE-Ph
	for linux-wireless@vger.kernel.org; Tue, 20 Jan 2009 09:52:16 +0100
Date: Tue, 20 Jan 2009 09:52:16 +0100
From: Hans Ekbrand <hans.ekbrand@sociology.gu.se>
To: linux-wireless@vger.kernel.org
Subject: Re: USB 1.1, usb-dongle, NETGEAR WG111v2, timing problems in
	association
Message-ID: <20090120085214.GA22704@sqlserver> (sfid-20090120_100218_703026_6058222F)
References: <20090117204654.GB9079@amin> <4972B25B.7070306@lwfinger.net> <3ace41890901191107g4100bb36j830ab31ab0202d13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
In-Reply-To: <3ace41890901191107g4100bb36j830ab31ab0202d13@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2009 at 07:07:46PM +0000, Hin-Tak Leung wrote:
> On Sun, Jan 18, 2009 at 4:38 AM, Larry Finger <Larry.Finger@lwfinger.net>=
 wrote:
> > Hans Ekbrand wrote:
> >> Hi list!
> >>
> >> On an old system with only USB 1.1, I tried to use a USB-dongle:
> >> NETGEAR WG111v2. The device works perfectly with same kernel (2.6.26-1
> >> from debian lenny) on a new system with USB 2.0, using the "rtl8187"
> >> driver.
> >>
> >> However, on USB 1.1 I get:

[...]

> Can you shut  down NetworkManager and wpa_supplicant and try
> association with iwconfig manually?
> Sounds like wpa_supplicant mis-config for me, so you might want to
> review your config.

A) The network I was trying to associate to was not encrypted.

B) I did try iwconfig manually, but I did not keep the logs (and the
   computers in question belongs to a friend, so I can't easily repeat).

Given A), can a mis-configured wpa_supplicant still be the problem?

--=20
Hans Ekbrand (http://sociologi.cjb.net) <hans@sociologi.cjb.net>
Q. What is that strange attachment in this mail?
A. My digital signature, see www.gnupg.org for info on how you could
   use it to ensure that this mail is from me and has not been
   altered on the way to you.

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl1kL0ACgkQfCyHKnBQYU48kwCg3OQCiyB3RN+H+dAO/9EJcxQT
buAAoJgFqbg3Hyt9vNQdwpVw3rnDsb8K
=f9zv
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
