Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:34569 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758AbZLFSpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 13:45:47 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/4] nl80211: Add new WIPHY attribute COVERAGE_CLASS
Date: Sun, 6 Dec 2009 19:45:49 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net> <200912061822.54088.8an@praha12.net> <1260122477.3461.20.camel@johannes.local>
In-Reply-To: <1260122477.3461.20.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3673864.I0TTtrovd1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912061945.53225.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3673864.I0TTtrovd1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 6.12.2009 19:01 Johannes Berg wrote:
> This patch assumes that all hardware supports this, which is not really
> what you want. You'll want to know if it can't be set. Yes, we assume
> rts/cts can be set always, but that's a _much_ safer bet.
If the hardware does not support it, the operation will fail with EOPNOTSUPP:

# iw phy0 set coverage 1
command failed: Operation not supported (-95)

Or is there a better solution?

Lukas Turek

--nextPart3673864.I0TTtrovd1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLG/vhAAoJEEBjvk/UOfYwoqYP/0pfaj8F+p41SkasT24nKcYe
G75LZ73EzvleeyUBM6M0iicR3n1T+XHbMfowYzIkXdL43EHWSYnn1y9wf6+oQp2X
Gv/FjUykPgTfH8cLpRk74p98AF2PhxxGw/uxNCoGPKpjo5eQ/s3RIxB2jMoTFo7l
x1xLprOwQZewLRQIJojdPk1gbukmE0dVIHHPv7kqC6asQ4dkzOeTe3NFR3mtO7iZ
fEdgUxg150hDRfogFtUHnV/eTZQHBkiaY7cvhv1uXpktQU1DKlaZjW7Imr27wtdw
iU0u0D3exz8UjKsxFZ5zaG1yT1lDeap3Hg6pVdFOQDdnUZX9pDLPh+LLkE3x2wMn
cCLCtT3YmnswbHNP4tb6JSkF3pYE8bRtDgrt3eAE2pCkAfngBeC13n1GGS0LXNxv
aBHBXYU0cDuyyRrziz0bp90yeNQRHkEo1aHMx0nXGn/RUkPzrAl1yPfOXIuKnpGX
C1QKloY4uhP2QQ1BOIgUTyVv1gVw5z3cwcICfQMy4vXEX10PlddDqQhDDR+94x3h
EqdzukD7zNqgpSqnDAq3EcNWsmCak8scc8Sm3qEOwvsTZnLPcC36G5wh7MKNZxS6
H0YiSPfovscbXpuB14Udwc1EGRxEuNwyyaSYLsam6ZfgFIdPlYaXY388Iycyf8Pz
2MqVsGFvYjd2gAtk1o8J
=BthJ
-----END PGP SIGNATURE-----

--nextPart3673864.I0TTtrovd1--
