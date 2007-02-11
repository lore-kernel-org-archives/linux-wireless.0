Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbXBKNYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 08:24:25 -0500
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Joseph Jezak <josejx@gentoo.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de
In-Reply-To: <20070209213239.GA11650@srcf.ucam.org>
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
	 <200702091811.40683.mb@bu3sch.de> <45CCF432.2070002@gentoo.org>
	 <200702091829.51002.mb@bu3sch.de> <45CCBB93.2040703@lwfinger.net>
	 <45CCC5DF.8010001@gentoo.org> <45CCCAE1.9080901@lwfinger.net>
	 <20070209213239.GA11650@srcf.ucam.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HabjsH22xbiwaB15Uhea"
Date: Sun, 11 Feb 2007 14:21:45 +0100
Message-Id: <1171200105.5032.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HabjsH22xbiwaB15Uhea
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-09 at 21:32 +0000, Matthew Garrett wrote:
> On Fri, Feb 09, 2007 at 01:26:25PM -0600, Larry Finger wrote:
>=20
> > My plan is to continue to maintain bcm43xx-SoftMAC for at least the BPH=
Y and 4306 revisions even
> > after d80211 becomes the in-kernel driver. Of course, I hope that we wi=
ll have found the killer bugs
> > by that time, and that maintenance will only require following kernel A=
PI changes.
>=20
> Just to make sure I'm understanding this correctly - does the v4=20
> firmware drop compatibility for older cards, or is it just that Broadcom=20
> dropped support in the driver at the same time as the firmware changed,=20
> and the new firmware will still also drive the old cards?

No, the older cards have a completely different MAC processor and
Broadcom hasn't bothered to create v4 firmware for it since they dropped
support for it along with creating new drivers (probably one decision
influenced the other, creating a v2 firmware is likely more work than a
v3+)

johannes

--=-HabjsH22xbiwaB15Uhea
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFzxho/ETPhpq3jKURAmT8AJwLO+5yZpmzpOOKMPASRjn/zqWaRACeImnK
CtK9IgSSd/ArTSLgFq4v/fM=
=c6OX
-----END PGP SIGNATURE-----

--=-HabjsH22xbiwaB15Uhea--

