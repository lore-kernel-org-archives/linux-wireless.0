Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hydra.gt.owl.de ([195.71.99.218]:40967 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXKNMRy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 07:17:54 -0500
Date: Wed, 14 Nov 2007 13:17:53 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Marcus Better <marcus@better.se>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Message-ID: <20071114121753.GB30575@paradigm.rfc822.org> (sfid-20071114_121759_090228_18513A4C)
References: <20071111102315.GC10486@paradigm.rfc822.org> <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com> <20071113192330.GA19601@paradigm.rfc822.org> <fhedc4$5l9$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
In-Reply-To: <fhedc4$5l9$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2007 at 09:58:44AM +0100, Marcus Better wrote:
> Florian Lohoff wrote:
> > You are right - its caused by a VERY low bitrate:
>=20
> Looks similar to the problem I have:
>=20
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/6830
> http://bugzilla.kernel.org/show_bug.cgi?id=3D9273

As you mention a quite young tree (2.6.23-rc3) - did you try bisecting
it on the wireless-dev tree?

It sound like the exact same problem i am seeing ...

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHOudxUaz2rXW+gJcRAvD0AKDSaTZhWblvY59ErfQYU7NVUYOFYQCfQpD6
ppVX5PCuoV0gK/tKDodC0BY=
=UDXg
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
