Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbZDWRmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:42:53 -0400
Subject: Re: [PATCH 2/5] mac80211: Fix handling of retry count of NO_ACK
 frames in  PID
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <69e28c910904231036r131612e3vabdab0302659fb63@mail.gmail.com> (sfid-20090423_193619_657906_B40E0EAB)
References: <69e28c910904231036r131612e3vabdab0302659fb63@mail.gmail.com>
	 (sfid-20090423_193619_657906_B40E0EAB)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gEGPKcVC5vo02HIWfgfK"
Date: Thu, 23 Apr 2009 19:42:21 +0200
Message-Id: <1240508541.30082.259.camel@johannes.local> (sfid-20090423_194256_232708_90C86304)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gEGPKcVC5vo02HIWfgfK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-23 at 19:36 +0200, G=C3=A1bor Stefanik wrote:
> Make PID check


>  rc80211_minstrel.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Hmmm.

> Patch also available as an attachment if Gmail linewraps it.

Can't you just use a real MUA instead for patch submissions? gmail
speaks SMTP, you know.

johannes

--=-gEGPKcVC5vo02HIWfgfK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8Kh7AAoJEKVg1VMiehFY9KYP/jXTPLr6psZOEznNT5FslkV4
S6IncpF+74flDMpz1vLiCUeNnrn+vT7bz2GPW6AXtLsHTGz67799qCzYnmAvy+mC
fm/yn+acG9ZMWTlCT2TSx3O+0EVg8+NsKscVI2NgKf9a4xWCOQNoN1jAtYOj766L
dfXW5lHE2b9PpxeyVMOxIo+PlQSUU30E5dLd5lHDxgMVKPGIupPiU9Dzdytr0/wc
+kEe5cxGtXZpLYG0vhd6FMiIyiNnWGLrCfiofpib4iv7nP4Bh127/pQEa99Z2bp0
B8sn58JRvkyNaUfpMQY/7afliGlmYJ8UBzLjaAykpU4F3KN8eNIfhlmIG+X8RSOL
lwWi/6loawdyfC2tJ4HLvtdjOe/JPhLZR//jwJqGofDnbv0QFTiEqkiYztuWqBcq
yzfWx0J7ruLdIC4yVRHImikQbJTpaECKKQWumQxXIw4dAfwhTyc7NQ1bX9WoTTMc
9Uq5w2hWqOPIpxEYgec9I9nid4NnuZTT3gvPhPL16SNnvyRd5jxLGpBLalZGdqI4
NUJy/ryUD4NrAjXWbsLTtIkSpsmISoaPS65pDRtMo87f/eoxG+BIlRlJyJ2/9bj9
r4cSmJhq0ooMd3jYiDuFfmFUPbwKOdMynrE5/8tTelnxRR2xy1JwDgTthKMbGH89
wpt1FbT5uwD3M9j25vsx
=pW4e
-----END PGP SIGNATURE-----

--=-gEGPKcVC5vo02HIWfgfK--

