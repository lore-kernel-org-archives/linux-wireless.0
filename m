Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:33661 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab3H0IXG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:23:06 -0400
Message-ID: <1377591765.5019.23.camel@mattotaupa> (sfid-20130827_102313_183452_05696316)
Subject: Re: [rt2x00-users] [PATCH 3.11] rt2800: fix wrong TX power
 compensation
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Fabien ADAM <id2ndr@crocobox.org>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Date: Tue, 27 Aug 2013 10:22:45 +0200
In-Reply-To: <20130827080001.GA2609@redhat.com>
References: <20130826131851.GB10525@redhat.com>
	 <1377548398.4408.4.camel@mattotaupa> <20130827080001.GA2609@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-LO09HnzEDa2vURRHEdkV"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LO09HnzEDa2vURRHEdkV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 27.08.2013, 10:00 +0200 schrieb Stanislaw Gruszka:
> On Mon, Aug 26, 2013 at 10:19:58PM +0200, Paul Menzel wrote:
> > Could you please add which ones you have tested?
>=20
> I checked 2 devices (3071 & 3070) but they have EXTERNAL_TX_ALC bit set.
> I assume the fix is correct based on vendor driver and it fixes devices
> which have no EXTERNAL_TX_ACL, but I can not tell what chipset that are.
> Is possible that the same chipset can be configured with and without
> EXTERNAL_TX_ALC.

I have the following device.

        $ lsusb -s 004
        Bus 002 Device 004: ID 148f:2870 Ralink Technology, Corp. RT2870 Wi=
reless Adapter

How do I check if the bit is set? Sometimes the device disconnects when
being 10 meters away from the access point. The connection is also
slower than with an ath5k device right next to it.

> > Is there a bug report about this?
>=20
> Fabien reported problem on mailing list, I can add that as reference.

That would be great!

> I hope it also fixes bug reported here:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D913631
> but I haven't get confirmation about that from users yet.

Understood!


Thanks,

Paul

--=-LO09HnzEDa2vURRHEdkV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEABECAAYFAlIcYdUACgkQPX1aK2wOHVhBpQCeNSOFOL11+mpdaT1k/FWGaftl
BNEAn3yjDl+yUrIMeQEMbE+mtaDfTip/
=wrN/
-----END PGP SIGNATURE-----

--=-LO09HnzEDa2vURRHEdkV--

