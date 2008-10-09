Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYJIJyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 05:54:45 -0400
Subject: RE: HT capabilities IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Nils Bagge <nbagge@bandspeed.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <6EACAD9615B47B42A780C005414307E1014956B2@mars.bandspeed.com>
References: <1223460098.3618.53.camel@johannes.berg>
	 <6EACAD9615B47B42A780C005414307E1014956B2@mars.bandspeed.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TdVN+iQMADPfHG+lyxL8"
Date: Thu, 09 Oct 2008 11:54:45 +0200
Message-Id: <1223546085.22490.29.camel@johannes.berg> (sfid-20081009_115447_545339_F836ABC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TdVN+iQMADPfHG+lyxL8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-08 at 10:33 -0500, Nils Bagge wrote:
> My humble opinion is yes, the HT capabilities field should be constant,
> from the perspective of a typical AP.

Yeah I totally agree.

> Practically speaking, I doubt that an AP would want to toggle SM power
> save at all, let alone on a per-beacon basis, as historically power
> consumption is not as critical at the AP vs. at the client.

True.

> But, if you want to be 'green'... (I can see how this would benefit a
> 'low power AP') The only problem I see is with the AP entering 'static
> SM power save'. You might run into interoperability trouble with varying
> behavior of client STA's, due to different interpretations of the
> standard or assumptions. It wouldn't surprise me if some clients ignore
> changes to the HT capabilities IE once associated, or if some ignore the
> SM power save field in beacons entirely. Hence, they could transmit a
> 2-stream MCS which would not be decodable with a single RX chain.
>=20
> Theoretically, the only SM power save mode I'd recommend for an AP is
> dynamic SM power save.=20

Right, but if you enter dynamic SM PS then it doesn't matter much
anyway, does it? I mean, there's no protection requirement in that case,
is there? Or am I reading it wrong? I _think_ I will handle the SM PS
change in mac80211, but I'm not entirely sure right now.

johannes

--=-TdVN+iQMADPfHG+lyxL8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7dTiAAoJEKVg1VMiehFYEFQQAJqlkBDvLIF/0FLTdAQKbXpq
FZ7R2PJ0LMvc4tJ7Jix7zNY5RT8oQCD126uk85lGp6L3Y6ubCCRG46bk83i9pPH6
N9MSWiftV6vfe3ZucZ29icpyZBUJwk5vyaluWQi6TgaS1fU/HftJaOtovbEHj3xe
zdMZK+eCdmiK0ZLIvLFcJ5d2YGDmlQkBTHbWWRUjpcn7zOAKppBMYsSkbOXbXxVF
NdMCg4XKmdda62xO8y5UhrCUHQtbEzyuTKAKvWzGizXWBivaPi77G/hSPX8j6XEC
iMiUo46TMtj4fr5D18tgEENixA3+PD+vC+giVQkxHXwSXspA2o8AhuEQ247+vP6n
08nBaotbrnEkpfnZWSWCeFiKpN/OZeT2JRfZM/wKv20FbAoQsyyXQ7F9pTL/hd6v
qUoIv1YKH6WpmQtVLwstzRuYVXH2NmwLpqteLsUSbB9vXkH/Oh90Qk3SwrXEzr+z
Fa41hEfdJclzpMkkYdYSmFSZSKEhpaLs0N1WSmTfTfsEULfidpnwjQBzinbD3Grc
M5PjPCOR8tq4PGFoEkPRLmPJqlSFtLrXsRhMQhU+bCzb6oMmgqfXHqx+Vk2X945K
MzTp1Ah6IloMczi9C2DUIJKX6bInNmq49BTiw7F7xaqWXt12CTb1B2EajYQUqJej
kt56Cgr3Kj5hV9tKD6xd
=l3KT
-----END PGP SIGNATURE-----

--=-TdVN+iQMADPfHG+lyxL8--

