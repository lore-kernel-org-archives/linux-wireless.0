Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbXKIMXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 07:23:44 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1194572631.4793.64.camel@johannes.berg> (sfid-20071109_120958_259609_BC4A521E)
References: <1194572631.4793.64.camel@johannes.berg>
	 (sfid-20071109_120958_259609_BC4A521E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sTZzMOyL6PAnKkkcR+bM"
Date: Fri, 09 Nov 2007 13:25:01 +0100
Message-Id: <1194611101.4793.104.camel@johannes.berg> (sfid-20071109_122349_065842_A704666E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sTZzMOyL6PAnKkkcR+bM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-09 at 02:43 +0100, Johannes Berg wrote:
> This patch adds support for multiple virtual interfaces (up to 65536)
> to b43.

Ok, turns out I need to do more testing, somehow I broke something, it
seems that the RX header lost the "frame is for me" bit or something. Or
maybe mac80211 has a bug.

johannes

--=-sTZzMOyL6PAnKkkcR+bM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzRRnKVg1VMiehFYAQIbmRAAms64mUadmREcHu28GaciLKarZ1A1SZn9
JC1xY+DWX+STEENrPs/RTn35coI5ysSW1c18zbLjWij6eRcOBkKJa786jfQclzGG
SVSqG/4R0gb4BjWeylhcs8ZsUG5UR+wY3vdCCr95JQkNLKtnaW6cb3CgKzpZQ1yt
dWW3Nzio6vRPxpd46JXL02iJD6j7UwWRrbQFbSYYW7kF+lBABavTwpTgVgeg7DrE
vrBBLs/aHqpogvUvTBLpPP4tP+gPjPcKEe4nI8mupJCIQXueiMkypCRN+ktK4vjj
EJlvR3t5Fs3+xoz9vE+EJwVAcued6OnoyGdhNADRkkwd1oeG0shUBcmuGcDagEvM
x2mSaoNRtyHv6u4kBa/41/R8sDXtsdZICi+4R1MT2QJl0gLNjkwoFHf5pRqNrWb6
ECNZ4m54uKa98joCF/aQgZwyo494fesZfB2SEedC9Fa4mAEutNy2GnCOUjK8WZDu
ZPwTqoyD0JuuB0Aa2q1LTohCQyjYrn3eC1EomeSzFFH1HPJSvHkjW3sIoX8B3po+
V/FRYo+scX4fmGlOYarntXloBAGMVjrtk65iuxvP08npV5YPX/6AJ89kpJdvcHMe
CPvabVwXAFXSmj3mK9qke6i5XUPO9StRf1BzMg8V4Ep1OAlo3PWhnaCbCll7TIlF
MyHuxyI5ybA=
=x680
-----END PGP SIGNATURE-----

--=-sTZzMOyL6PAnKkkcR+bM--

