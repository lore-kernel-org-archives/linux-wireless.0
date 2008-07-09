Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYGIRnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 13:43:22 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091812.55271.IvDoorn@gmail.com> (sfid-20080709_180405_809148_FE4B19C4)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <1215618570.3246.30.camel@johannes.berg>
	 <1215618957.3246.35.camel@johannes.berg>
	 <200807091812.55271.IvDoorn@gmail.com>
	 (sfid-20080709_180405_809148_FE4B19C4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8aqu1RDzE6098Rx6sqsL"
Date: Wed, 09 Jul 2008 19:42:35 +0200
Message-Id: <1215625355.3246.41.camel@johannes.berg> (sfid-20080709_194325_705461_7D3D2CA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8aqu1RDzE6098Rx6sqsL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 18:12 +0200, Ivo van Doorn wrote:

> > I'll put off the fix until after davem's TX MQ rework though.

Actually, I don't have to.

> Ok, that would allow some time for rt2x00 to come up with the
> implementation for the rt2400pci and rt2500pci drivers.
>=20
> And this is extra motivation for a volunteer to look into this,
> because when mac80211 removes the seq counting, it is not
> just adhoc and master mode that are broken. ;)

Here's a patch to try it out:

http://johannes.sipsolutions.net/patches/kernel/all/2008-07-09-17%3a38/022-=
mac80211-fix-hwseq.patch

johannes

--=-8aqu1RDzE6098Rx6sqsL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdPiHAAoJEKVg1VMiehFYKWcP+gPkzwQheSDPLkFWjSFyJBgU
TA2duFHL3XYKZXkDpRoxdSJ00HtiGACXJIaTpH6sacv7T9s8FQ3W+loWWgDb2Bf0
NurYE7CkmMFgOpeNfdagzPuZ+P0AX3FiQw1ebChzESBTW7b5vTsVQybpClzIhCLG
DwFJNus/Uc3ETmXuIRZDYBxK2LInpGv9Hy24MWECqN2zw0ehWle5HbLA4jXHiciV
sKeRTfmeWUrGS5iGVQf3oh0ZyW/ArVx2lkm/H2r2iEaURf9Uv9VoteWkaowHcNaX
VQsU5mz5s2d7MizcFLm74qf569FJPkq0EvhjMZL+CaxbbYmoxxMheN8NK1DxTocn
FWhvjatL6LgTYHt+Vg8oCZR8y2N+3TqHcESzJvdOa/2KdauCukeWU7FfoZudu1oQ
UWgGHebte6aUWJJv/ifU3XOIoe7zQagWvevxTP4RpIO2A10WnOWlBT41L2HbBzkI
6wpGr4d8VnO0GdSrjMS7JwwxMhSMq59Zf39TscK1qJ3ecQ4IdxAVrrNfL8NoqGPe
nxGg3N+v4vf6O2FHxqA+GWl7iM5NBldtyyYa/rJKx05xy2/EUlvp8qMZm8sPZv2G
iXY30+dqoe/tRh1KvF/rU5QGguIq8zxpBjUf0/GyPSgtukrP+ESVRABEnZOL0Imo
4x9+YvV6GmNnYSmn7pR/
=pyXp
-----END PGP SIGNATURE-----

--=-8aqu1RDzE6098Rx6sqsL--

