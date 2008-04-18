Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYDRMNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 08:13:06 -0400
Subject: Re: [PATCH 1/7] mac80211: michael.c use kernel-provided
	infrastructure
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1208463227.17196.23.camel@brick> (sfid-20080417_211430_332902_F22CD497)
References: <1208463227.17196.23.camel@brick>
	 (sfid-20080417_211430_332902_F22CD497)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xC4LwseSCWL1lKYm0w6R"
Date: Fri, 18 Apr 2008 14:12:57 +0200
Message-Id: <1208520777.4848.15.camel@johannes.berg> (sfid-20080418_131313_165760_A9166D84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xC4LwseSCWL1lKYm0w6R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-17 at 13:13 -0700, Harvey Harrison wrote:
> Replace private implementation of bit rotation and unaligned access
> helpers with kernel-provided implementation.
>=20
> Fold xswap helper in its one usage in the michael_block macro.
>=20
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> John, this depends on the unaligned access helpers going in through the -=
mm
> tree, and will not compile without it.  This is a collapsed patchset of a=
ll
> pending cleanups I have for mac80211 and supercedes the patches I have in=
 -mm

FWIW, I gave it a (cursory so far) look and it seems fine. If wanted, I
can test with a TKIP AP in both hw and sw crypto modes.

johannes

--=-xC4LwseSCWL1lKYm0w6R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAiQSKVg1VMiehFYAQIKUhAAveYML+1lPBxwJYVbnstLtoAgNLHo8jqr
dw5adNH2zCklKn5XJ2abpFhPooITB9wdjf1nMRbkmsV2RH5RilLsLKKSuPxGMe56
bFCzcvm1baplLHDM13s8Oev4zrLPMCYRO8JBt0yo59MRzeJV8wjwMqCbKDddhVaI
dy3gORCgU1kuE9FcK91Olwa3xnmekJySYeFOv+JW3LXFKXdRdPHjATLYZQQNRksw
9bKUkQIi6vxgyuTvq3XCVoAOFxOJP2bEbVEg8DsSk1sxZ/tCRoWTVHmOmI8G9p8x
eaD7l0CbF1ATuO0EeEj45EexwnO/i3h9CU9YaCaoH0+MeX8KhVBZJCUjbI2pZsj1
M96sIezYHRXr7KBCN5BUNtdklQHEmQvq5LexJkaf5eAfMkIHMbBLJnTXDJWpxEEW
SSacUwZEUkqDhcVIFJeCDvin8QYbeTY6KJJqGetOhM9ozKrAAVQyc9lztiOlspA9
7+eXMxApCRi0667gabBpi+1FXJOm5uhpW0VhaesklQWeIoJoPd3w745c0vtqlOf9
080RWLJfox6j8E8eG/X90Rp88gbMqFOhyMDxyUAiIL5+3ManHjjq/0R9VgEidEfj
fVRpUMiN6dWvtxythmCoRMwEpMaVaYUw69S6HygugAmFBA8aKhZXlrvEgzXCD4R4
SKBNlM+R+WA=
=4EL6
-----END PGP SIGNATURE-----

--=-xC4LwseSCWL1lKYm0w6R--

