Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:40676 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZUql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 15:46:41 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] API for setting ACK timeout
Date: Thu, 26 Nov 2009 21:46:47 +0100
Cc: linux-wireless@vger.kernel.org
References: <200911261826.08576.8an@praha12.net> <200911262113.10847.8an@praha12.net> <1259266544.5428.0.camel@johannes.local>
In-Reply-To: <1259266544.5428.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1377993.Fc8xXOarFB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200911262146.47311.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1377993.Fc8xXOarFB
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 26.11.2009 21:15 Johannes Berg wrote:
> It only affects lost packets anyway, no?
Yes, it does, and 6us is still nothing compared to the transmit duration
(at least 100us).

> Would that be sufficient? It'd be kinda cool if mac80211 auto-configured
> itself if it picked up a beacon that had this information, etc.
We just need an API for setting ACK timeout on long distance point-to-point=
=20
links, so this is definitely enough. Unfortunately I can't promise I will=20
have enough time to implement the automatic configuration, although I see i=
t=20
would be useful for us too.

Lukas Turek

--nextPart1377993.Fc8xXOarFB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLDuk3AAoJEEBjvk/UOfYwM+AP/0HQDaoNizg7az+kEEyOXjvp
VMQJHfMwS7JjtUZelKM0ix9J3h/AZoFTWkkjfp/5hOIuLkWe7zEdtx17bbjKeNq2
J5I8fRZvJDy2oEaklPV83tHenOgDf7AmeYOkj4pSIC5ye0yOsrgJDb18O3+R0HvX
WQDnuuRHNAJ+2WZz5amw98AM84DHHFwjJQUosSsPFGtXct+IWU77QVu6XTSlAkJx
Oiimt9divMGRNPLyTZ9KF1IbwtQsVucwJoNL38Vf3+o58E0URvZ7pPIjazj0TeM2
XUFCMpMxqOeJ2hMsqtxOKfAq0ggUMhhRIFYdH/TQiYljZir+EPVc/we0aS6sCRps
W37xlO4PHQLt3/1JA20otCQR1FabVtLQed68OyejbeQjdwSF1qwK4qSFpZfjBK+v
OQR+cVNW0CrmH7pERyJNIl7gpu4oJrnjTC7nj7BcaBsqQP431pXJ+DnjSJLBQKPT
KOp2aww77HEg9QqHtXM93KewTEn2SvUVsuBvemRm9hNp0BKgPxjiRKFgSgOycHlm
OrQ1aEx1jE8fK0H5rTkro7KAgkftEvJVfyyjlGqm/395ifSyaGhVln+2rEy7+JTy
IJb2dsmbuPvXlCcyGg53Mt47K0KKcFQPTcA/NEds+VgP6B2NE4l1sAiWGomjWcfU
nnYPqQY3r6OUB6giECam
=+SHW
-----END PGP SIGNATURE-----

--nextPart1377993.Fc8xXOarFB--
