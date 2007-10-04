Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbXJDSQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 14:16:35 -0400
Subject: Re: [NOTE] driver caveat
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071004131019.GC6037@tuxdriver.com> (sfid-20071004_143906_154438_EAD285D8)
References: <1191480634.9898.30.camel@johannes.berg>
	 <20071004131019.GC6037@tuxdriver.com>
	 (sfid-20071004_143906_154438_EAD285D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-l303yEUErFaa2rTTfPXZ"
Date: Thu, 04 Oct 2007 20:16:55 +0200
Message-Id: <1191521815.7367.8.camel@johannes.berg> (sfid-20071004_191639_424586_0FD767B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l303yEUErFaa2rTTfPXZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-04 at 09:10 -0400, John W. Linville wrote:
> On Thu, Oct 04, 2007 at 08:50:34AM +0200, Johannes Berg wrote:
>=20
> > If you've been experiencing bad behaviour with suspend this may be the
> > cause, instead of working around in the driver I suggest you implement
> > proper suspend/resume hooks in mac80211 for drivers to call ;)
>=20
> Proper support for suspend/resume in mac80211 seems to be an issue
> that could use some TLC.  Anyone up for the challenge?

I already added helper functions for the keys which are the most
difficult part along with the interface configs. Phy config should be
simple.

johannes

--=-l303yEUErFaa2rTTfPXZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwUuFqVg1VMiehFYAQKa9Q//Ro1s0g3JWKp6xBubhv0E97sycc4fU56v
GqPwXf/3I9ZMTZaoOfsJJlT9oL2SFQCbXCL4XTpOUQxjrsNU7rASo+5Aym6neEqB
w4aSG3KLjwenRAqDeFb23IsJZr2Y2hjkKU/fM6NEIVrRs0nuS0H5KCHiHJkhBvpA
R0EAQcG9pBzV6iTd905pdYHDb6EXszNFCykuHH/6kG556Dwf3xveSofc5XGx+YDG
fP4oX7NnuUFGfXD9twi7Jc/DwqDOccqOLZh0LFJj8f07rZuxXJLh6n7etn8PVqqD
320V/SK/UmoYYbq4PAnvlw/MDCoS6/VyWHMAGXYLXCoYNMT1M9cNMAaO2lJLbCe5
Wx5CoAKbPQltjbpn2rMetsUSEyJMPlESKTpyb83/AOGRc72ZhgQX+rE2nG5b0DmD
DFbNmIYNRs94Sj3qPgqSEGLCx0DGbNMRW2vLdyd9cFrTZqWekqxNVP0CdChWtfTe
xIhzUKLiqetiM4YJhdXFAo7xCG0CMefWw+nxTu8cgHk0atMbFO/xOV88nQ44Fyao
TI9iHvRflBxgyJZ6ebOAMtGrMyRfJ6oxgVlRxSv/6xNzsgnbWD/No8/muMLuFjZK
ZV7g8cQDA4hoT6UL2ifxfJmXqtNQbZhqZAFCNT8QireVMi7IQvfgg9emNtO/lZWj
Al6AAzgaRg0=
=Q3V6
-----END PGP SIGNATURE-----

--=-l303yEUErFaa2rTTfPXZ--

