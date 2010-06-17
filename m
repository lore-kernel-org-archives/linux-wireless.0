Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:35568 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305Ab0FQKES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 06:04:18 -0400
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Bruno Randolf <br1@einfach.org>
Subject: Re: [ath5k-devel] Race condition in CRDA calls?
Date: Thu, 17 Jun 2010 12:04:03 +0200
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <201003251801.57951.8an@praha12.net> <20100526214658.GB10931@tux> <201006171347.58712.br1@einfach.org>
In-Reply-To: <201006171347.58712.br1@einfach.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1550743.mYYqGx2k0C";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201006171204.11831.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1550743.mYYqGx2k0C
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 17.6.2010 06:47 Bruno Randolf wrote:
> are there any news on that? i think i hit the same bug, now...

I have an ugly workaround that works for me, unfortunately I didn't have=20
enough time to really fix it. It may involve rethinking the communication=20
with CRDA, I think the global variable last_request will have to go away.
I reported it in linux-wireless, because it's a generic mac80211 problem,
but I also didn't receive any useful reply there:=20
https://patchwork.kernel.org/patch/102727/

Lukas Turek

--nextPart1550743.mYYqGx2k0C
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iQIcBAABAgAGBQJMGfMbAAoJEEBjvk/UOfYwYEUQAIUCLSCatUBGu3VDskJv6YDM
DPYeOB8hhWg8Yoyfo8cg5LezdAMzJMvDHRXfXuR7wRSR3wbXD19z4/d+Bw0IeH2f
V/n5hSIqFpFiqk0VTqlVW3NkqIr3smAF6O5sMOkeM/KdTjnJODWkTwGMF/HTwdlH
TXEIw2XeqnrgbTSmJOXIppRgbEvos+Kf4KWLh0JMswAnwp6iLZmzkfDKBEBNQBU3
BNHGwWcU8qrtONIpUsyNQmTgBplMim6KcfgtsOgBLfu/rPWcodRWh/oAhJdFP8OB
3zfeg09tjKB3tHGexvT1qDicf1eWUtwyUOAVWX6gIPqUdgUxqh7I1h3D/mW08w12
+aTHqYqQD8wgTc9qnC27jxXX1KbrZElPfw6nMbyuBdI1h6y2KHXYjsCUoXmGDbKS
AkyBZyon0Lmntr1mOX2ltwokn/BOS2QUkBqXPQDMB4TUNTFH8mJrzZFzHLg1PxVb
C277ESUKNyRPGD54C5bT25fKPd1QL6hEraI6EHhuvM7WQSTCvvrteIZ69kHSeCZz
m0XDLDJ8EXRhbKnIc2xcf+rOaB9K/p6Jvz7eGMouhGeEm6SHanXv+XSSIYbz1w6H
fLs+5tjsPlWqEfBmdW1Uci3a1Pec2MrqZNSjlsdffYQGrquZ5MstKQ2wvDARkn8R
bWnnO9bGptfj4MWuJEhF
=M0uY
-----END PGP SIGNATURE-----

--nextPart1550743.mYYqGx2k0C--
