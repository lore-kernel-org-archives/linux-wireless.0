Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0ATKVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 05:21:12 -0500
Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe
 responses.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1263919339-5755-1-git-send-email-benoit.papillault@free.fr>
References: <1263919339-5755-1-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TSWtxVUUB+RFY4CHGGqN"
Date: Wed, 20 Jan 2010 11:21:09 +0100
Message-ID: <1263982869.14538.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TSWtxVUUB+RFY4CHGGqN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-01-19 at 17:42 +0100, Benoit Papillault wrote:
> The same code is also used for probe request generation

The code is probably fine, but on its own the patch is wrong, so we
shouldn't merge it.

johannes

--=-TSWtxVUUB+RFY4CHGGqN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLVtkSAAoJEODzc/N7+QmaTsEQANPKfmxd2P6B6NkpNE37i0Qe
I5KjjKUvi7T5aPkHLZrw8yI9YdLLadVyPjieYuZDxP4si8w5jpRQn7glWXWpAEV0
9V+fuu6L+N8aYOTGJq6s8EaUxDTtJo8meXxdYgWeo3oOoQmlQ8SoTdqoBepmPL2U
JsMjNcyWIO7pVzUfrmIM3igzp2VYDzKvYXmUEmoOmsuvGA19lF9MAHWZFQirD51p
YsVoTVbmVrNSdz2fvdaJFpKHVtZuDwj7P8EsCZBAHUi44m0mBShKvJbRORqxPmtx
lZLuIWkqlHx7qhuWBWYCn4um4Smlyng4af97ic8PzrBCLsDL2FrAXwd/Wv3AV3rz
tJA0R94c13X+dV5PpLfPmka5fnoY8Qkky5y1X2+2tcHds0jZm/Qud2ok/rs8ast4
osYYen0DRznP/iS1RSCLesLgwuXu4TcnmNXIfssysG0kU/+lMv4Vs0pHkKKtPbYq
+DlIGPdb9L1xRNEO1HJJN5AS7QJrOzeDtbUgNYmKwWb0/3druZTpGPqZPHXQQ2nq
+qsh5bmiyo530NiTEu5c+zIvyP2x5Q20cjK7DHhkZDBZ/WvjgR3Z8Ow2arI6v8L1
9qIWpMvmNASP86HqN5M0ckw/+6t4xfJ69LEopzmgPCWnSjLVVTd+tJq0oi+mGjFi
h+AmmWwv1P1aOUXFCUUr
=sXqK
-----END PGP SIGNATURE-----

--=-TSWtxVUUB+RFY4CHGGqN--

