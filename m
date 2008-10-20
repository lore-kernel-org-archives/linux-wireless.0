Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYJTGPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 02:15:46 -0400
Subject: Re: Power saving on mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <43e72e890810191846h46a6b35br4ad61803a25bdf23@mail.gmail.com> (sfid-20081020_034700_160658_5C77DFDA)
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	 <87bpxh6t1n.fsf@nokia.com> <87y70l59p4.fsf@nokia.com>
	 <1224412006.6324.45.camel@johannes.berg> <871vyc7st7.fsf@nokia.com>
	 <1224434885.6324.49.camel@johannes.berg> <87myh0a1zd.fsf@nokia.com>
	 <43e72e890810191846h46a6b35br4ad61803a25bdf23@mail.gmail.com>
	 (sfid-20081020_034700_160658_5C77DFDA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zfBRGaH9zQD01sr+iN5K"
Date: Mon, 20 Oct 2008 08:15:39 +0200
Message-Id: <1224483339.6324.55.camel@johannes.berg> (sfid-20081020_081549_848593_EFBCA4E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zfBRGaH9zQD01sr+iN5K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 18:46 -0700, Luis R. Rodriguez wrote:

> I wanted to note intel hardware seems to handle parsing beacons in
> firmware when is PS mode already and I have no clue when it would
> inform mac80211 of a beacon miss and if it does it. Tomas?

It doesn't do anything at all with mac80211.

johannes

--=-zfBRGaH9zQD01sr+iN5K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/CIHAAoJEKVg1VMiehFYf8EP/2gV3MjIpcgVsvsFcMXcZMTc
Aw6MrVnPqLrt7CyK9TOfo+1vBAV3dBmRMObtdAuvQlOsdoUcPoIbZ0b7DeMCJh1y
fvcZtbtpL6YDrfh0tQcpFIpvL6HKhcAGOyww7SvfeD0FU6xMjvgbAPP3pBcT8sgv
F1DBqSpdYM/kAfmxpi0vReemNFySlQe33KfFc0iAKMEZaYF7lSSHPrp/Ivo1cRU7
tSF5/Mp0Dz+qVAdq1bPsK3H/eKtyM9K1lOa3/PzOSJUoLMr5lKu03t4wgQawsCBl
f8ffM/ma4MYm3z+SWW2MsTjT6sR0iVxriR8lDQ+YFmyfLXYJcxevTLdNm5PpVIhY
nQgAIs2p61LPwXBC9tGdschHBiEQp/SOyJFJ0O3y9n0N7Px6zjK/R2MHiJ4wn2jj
n0r+bUvIXeTis92qoMmkz9t6W1B6PObs5OmqZ/pG80pCuuoLGYJdHVv4G4ZSywP3
CGl1CFdGSXoypkWX5HlpJ0RcsfC6lESMsr6/2RTwY4Cn/v+mnRx3GAVfo1+BuVD4
jU6PsjYRbddig5Ffjv8yLIV00SwNTN5/Pp04na6zAKYJNVQMonncrVF4op135KHB
xFN4g1RWJ8nL9PRdc7B6aAYpRg6n2YhI0u4utd00TR2D46xdk8TFRUIzyPYxM6VK
EZemdsFeMBjaZmALd+wH
=w3sX
-----END PGP SIGNATURE-----

--=-zfBRGaH9zQD01sr+iN5K--

