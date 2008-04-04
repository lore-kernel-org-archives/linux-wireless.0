Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYDDPu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 11:50:58 -0400
Subject: Re: [REGRESSION] BCM4306 cannot associate with any version of b43
	driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080403215406.6fafe376@peterson.fenrir.org.uk> (sfid-20080403_215411_206840_ED6D4BF2)
References: <200804031115.52596.ace@staticwave.ca>
	 <pan.2008.04.03.17.47.01@telenet.be>
	 <20080403215406.6fafe376@peterson.fenrir.org.uk>
	 (sfid-20080403_215411_206840_ED6D4BF2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JghaRsTfKTK/o3VEMnta"
Date: Fri, 04 Apr 2008 17:50:55 +0200
Message-Id: <1207324255.19189.63.camel@johannes.berg> (sfid-20080404_165104_029641_3536625E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JghaRsTfKTK/o3VEMnta
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I had a problem with the iwlwifi driver in this regard, my AP is on
> channel 12. Scanning found it, but it wouldn't associate. The option
> string above fixed it for me.

FWIW, that was recently "fixed", scanning will no longer find it.

johannes

--=-JghaRsTfKTK/o3VEMnta
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/ZOXqVg1VMiehFYAQKEeBAAo73V2cS5yLKnFs0nV/lzycUqEAncnfF7
t29+UfCFrkShsw9W5PcItjT1ArN1W+cEKOo/8h9R0vvsHQNa8i3MPssMQbhHOUXk
P787fzvu57sFdgOEmJHq701cJUmVAEKOKpxYomCun4wYwAEN6hOgA5zp5CSHLTnP
sCOiWS7c+qDz6iYVs27SIOumhXskjm4v+BJHIcLV4aO0GKnlyrMO8L0p3z8wV5h1
lgcGHjY2JthTWbd0tt4gOQ0g93mhhqZnZ85bcoJGAu+nS7nwzwR3LR2fbJg4xhJe
zBQl6KW2gpIuHUWZl+i+o+Z07AC5R9VLRkT6EqRx3JQgKlNFlADEv+tXkyhRW2w+
g+MKrOeLNKPbbaQomhk3B7X4ZJbmP1aqB3B1ks59qcp5UHDAGK5406j+CWYpu555
KMg8KunDzP339+iT/uMyYZsnsHXlo8Cakq1hLlYg/k3geaMFA+TJgwEGg0KWbomF
fBawZroTEjlR2M5h+gxnUHgX8/Ucvlc3CmjDlXivT+frYYCfrdm/JcJQDb3i+54R
tZKObijIGzEiOrjO03LudlANm7V+ellWQtbOG25XnZD4xPEDKUKUFReM/n8xFuD3
ZClByFaJPbsVKkEwErLBRNnRFB2veBycVD7V/zZeTIMJRlzY/9NpHXOY/dwfLkFg
uDaMlc/w1+I=
=BMaO
-----END PGP SIGNATURE-----

--=-JghaRsTfKTK/o3VEMnta--

