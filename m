Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:37633 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750853AbbEYTbn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 15:31:43 -0400
Date: Mon, 25 May 2015 20:40:47 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi: Queue 16 stuck for 10000 ms - Microcode SW error
 detected.
Message-ID: <20150525184047.GA12142@light.dominikbrodowski.net> (sfid-20150525_213147_360083_4DE38D3C)
References: <20150525181043.GA10755@light.dominikbrodowski.net>
 <CANUX_P0+oGdKvY360xSekCmZjZFpe7PMS+shC9==-G-A-1O3sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
In-Reply-To: <CANUX_P0+oGdKvY360xSekCmZjZFpe7PMS+shC9==-G-A-1O3sw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 25, 2015 at 09:27:39PM +0300, Emmanuel Grumbach wrote:
> On Mon, May 25, 2015 at 9:10 PM, Dominik Brodowski
> <linux@dominikbrodowski.net> wrote:
> > Hey,
> >
> > on my pretty new iwlwifi device 8086:08b1 (7260), the following error j=
ust
> > appeared twice in dmesg on 4.1.0-rc4+ (Linus' tree as of Saturday/Sunday
> > morning):
>=20
> Firmware problem. Please try to update your -13.ucode from the git
> repository (https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-fi=
rmware.git/)

Thanks, will test.

	Dominik

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVY2yvAAoJEJqXYIlMjaMNlRwQALDXhqvuLMEmzwe7BiDFCOlc
qNb5CXP5L0dafrg4EoVALu0SLEDng1WpgcaCy5wtP3kWndLS6DU2V03UnUOHT8H1
Z5Evq5ktyW90GISw5i0mo/L18xuhGTq0UdswKdVPezmCgSzy9QULirsqC/yamMFK
T2m+1F44/uIa8rNQginu1vyV5sDgiP5A9wMvMOul4X8KA8VfI14bZKsRDaOUIJWp
vSA2pPFj9wb3NNbVdoaa/ieDIsJsv+iiGCpgbScdEjHn8x0mjIjplGrIae9Zw7rf
bz388Jwl8zYUX0UkyY5G9LQQ/ku+EyEwgLjs4p5XwUHeOOeZoXSYFyh98bVVw7KE
BaedHuIXjhPR43AirZJOOJPw7JLOzp9mNTdHg4rZv6iro+5ITNCxsXTiomUD4btk
+f0CkV6kMBhNRH1n6KaDAlGAhR2PysGpJWuLM3Shim2Uh7EhdpMJ+YFY4WUIsPuE
JT8nGtoRfbWCzjgbQ6ktwF1U3AKeHZ2kkkfcvmPJ2rKZ3vc0BDv9P6by5Hzwpi0f
hh5XtNZTd/Eq60g3A5d2dcH1Ke6jewWq9EdG2opqVdFJqF0qzWSTGdVzKlRpCrso
RgpBwLfy/re+ZEO//FnV/3t4t3aWNT+LcgMVR5AJl9LB7lD7jUwPsugygScW+8bj
2MxxqLrNZPF7h6ugmK9I
=HF2y
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
