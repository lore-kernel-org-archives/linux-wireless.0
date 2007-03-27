Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbXC1JL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:11:28 -0400
Subject: dev_mc_discard: multicast leakage
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fzr+BvgVCXXkVggrMFDW"
Date: Tue, 27 Mar 2007 02:07:28 +0200
Message-Id: <1174954048.25887.77.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fzr+BvgVCXXkVggrMFDW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I just got the message:

[119933.809902] dev_mc_discard: multicast leakage! dmi_users=3D1

when I had created two monitor interfaces and deleted one of them.
Anybody have any idea what could cause this?

johannes

--=-fzr+BvgVCXXkVggrMFDW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCGBA/ETPhpq3jKURArFaAJ4gcQ/XUh5h4i9kqS58xPlmHS4g8ACfW1vk
YBOXfOsCnX4XFJF4eA6E5/U=
=5rDA
-----END PGP SIGNATURE-----

--=-fzr+BvgVCXXkVggrMFDW--

