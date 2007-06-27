Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbXF0OBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 10:01:18 -0400
Subject: Re: ieee80211_rx_mgmt: pushing fake 'management' frames into  userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Mandy.Peng@infineon.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <A2CE5E0A70B68046A98EB5145552E27701173B8F@sinse303.ap.infineon.com>
References: <A2CE5E0A70B68046A98EB5145552E27701173B8F@sinse303.ap.infineon.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6ePU+kAe5oZwMr9D3kfU"
Date: Wed, 27 Jun 2007 16:01:29 +0200
Message-Id: <1182952889.4769.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6ePU+kAe5oZwMr9D3kfU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-27 at 21:25 +0800, Mandy.Peng@infineon.com wrote:
> Hi,
>=20
> I have a problem about the relation between mac80211, hostap and
> hostapd. In the ieee80211_rx_mgmt( ), it pushes a fake 'management'
> frames into userspace via protocol ETH_P_802_2. May I ask which program
> will receive this packet to handling management message ?=20

hostapd and maybe wpa_supplicant

> Where can I
> find the suitable userspace management program to work with current
> mac80211 ?=20

That would be wpa_supplicant when compiled for userspace MLME.

However, don't worry about it, this stuff is going to die.

johannes

--=-6ePU+kAe5oZwMr9D3kfU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgm24/ETPhpq3jKURAkkZAJ96ypXkewZyM9djvr6aWoMc4WC3OACePPnh
vWW0VPQin+50wQVE7jCThCY=
=vAgz
-----END PGP SIGNATURE-----

--=-6ePU+kAe5oZwMr9D3kfU--

