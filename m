Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:54211 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab2H0Gya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 02:54:30 -0400
Date: Mon, 27 Aug 2012 08:54:19 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/2] ath9k_htc: remove driver specific checks for
 interfaces combinations
Message-ID: <20120827065419.GB22073@ritirata.org> (sfid-20120827_085434_600693_C795223F)
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
 <CAD2nsn16-uZ0CbBXrHjUS2Rwn53OYNrLvjujmPAwGDCEbdYJxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
In-Reply-To: <CAD2nsn16-uZ0CbBXrHjUS2Rwn53OYNrLvjujmPAwGDCEbdYJxg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mohammed,

On Mon, Aug 27, 2012 at 10:47:29 +0530, Mohammed Shafi wrote:
> Hi,
>=20
> On Mon, Aug 27, 2012 at 2:25 AM, Antonio Quartulli <ordex@autistici.org> =
wrote:
> > Thanks to the new interface combinations code we can safely remove all =
the
> > driver specific checks for unsupported modes.
>=20
> i had just sent this some time back
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/96443.
>=20
> please review if something had to be changed.
>=20

Sorry, but I hadn't seen your patch. Otherwise I would have not sent mine.

Your patch is ok. But, at this point, should patch 2/6 and 3/6 be merged
together?

Other than that, patch 2/6 should be modified to take into account IBSS mod=
e.


Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlA7GZsACgkQpGgxIkP9cwdZyACgkMrhvvYaYhslCxyYskNUHIOG
4m4An2m3uGN4VMebyWQ0Mi1KCoB0rLQV
=9KLw
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
