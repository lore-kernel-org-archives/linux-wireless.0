Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:57211 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760794AbZCYPm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 11:42:27 -0400
Date: Wed, 25 Mar 2009 11:43:21 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: G?bor Stefanik <gst@remote-exploit.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ar9170 - Cace Airpcap NX
Message-ID: <20090325154321.GA4368@drd1813.lan> (sfid-20090325_164232_948249_34C40529)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <20090324202633.GA21202@drd1813.lan> <69e28c910903241614s5502a7ffoe85bba0515b8c223@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
In-Reply-To: <69e28c910903241614s5502a7ffoe85bba0515b8c223@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2009 at 12:14:34AM +0100, G?bor Stefanik wrote:
> On Tue, Mar 24, 2009 at 9:26 PM, Mike Kershaw
> <dragorn@kismetwireless.net> wrote:
> > The Cace Airpcap NX device is an atheros 9170 USB device (sold with cus=
tom
> > windows drivers for rfmon in windows).
> >
> > Works fine once the USB device id is added to ar9170, device 0xCACE,0x0=
300
> >
> > -m
> >
> > --
> > Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
> > GPG Fingerprint: 3546 89DF 3C9D ED80 3381 ?A661 D7B2 8822 738B BDB1
> >
> > Supercollider Programming: The art of debugging your program by
> > letting it crash and looking at what remains.
> >
>=20
> On a related note, the Cace AirPcap N (PCI/Cardbus/PCIE) is an AR5008,
> with the PCI ID CACE:0023 (PCI/Cardbus)/CACE:0024 (PCIE). Someone with
> an AirPcap N should test if adding this ID to ath9k works.
>=20
> -G?bor

Works with CACE:0023, don't have a 24 to test with.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

If you can keep your head, while all others around you are loosing theirs,
then you must be the one holding the axe.  -- Anonymous

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknKURkACgkQ17KIInOLvbHY7wCeInO+Li/WD/lzJY+ztijcbrti
L9UAoJzn3QzidGesfE43ZWsMAmhTaPj0
=I+wo
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
