Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYG2Oui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 10:50:38 -0400
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <488F2D64.902@lwfinger.net>
References: <1217323927.10489.9.camel@johannes.berg>
	 <488F2D64.902@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YctAB83Y4MNxvQCRe/t3"
Date: Tue, 29 Jul 2008 16:50:28 +0200
Message-Id: <1217343029.10489.77.camel@johannes.berg> (sfid-20080729_165041_684487_E75EFAEE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YctAB83Y4MNxvQCRe/t3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > This fixes wireless. At least it works on my WPA network, I haven't
> > actually tested a broken kernel.
>=20
> This patch fixes my broken 2.6.27-rc1 kernel using b43, which had not wor=
ked=20
> since the new networking stuff was merged.

Thanks for the heads-up.

> I'm pretty discouraged that a change that has such an impact on wireless =
never=20
> made it to wireless-testing, where this kind of defect should have been f=
ound=20
> and fixed long before it ever got into mainline.

I had tested earlier versions of davem's patches, and those worked fine.
and I guess that since he was not aware that mac80211 had always been
using skb->cb in illegal ways, he couldn't realise how it would break
wireless.

johannes

--=-YctAB83Y4MNxvQCRe/t3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjy4xAAoJEKVg1VMiehFYylQP/jaE3X3caKASDzKIy9IQYWU8
qX0JFwGG5bej6Rxtu7sG5pP1WSALs3GLXwRNUFeuGko+Ck1gpHMQ24TeRZmVJ9xi
zk9SAlD3pwigEIfOBPTSutll3ycK7BRlYwBZPfC1dWQBTmaz23VHMu4+wJGi9LfM
+i1MItdYv3m8VvshtkGjKyuRHxFOLo34fepVSgkqrbBy5e5mWdGdHuRZi4xQtuab
wqAn9NFMxPf0BaSnxxINgh1hGTGi6wqLcVjwJdAAtHKmI8JCVDlCd6cq5SAc5fOa
SxkYyUjo85X6X8eFx6K6HEj+V63kQIrcbOkBmOro4PT3D3mmi55NBRIpgfnCH1+u
5fwT1+BmUliNY6ErO0ruPB/xdp7Xd2y4AEtNqm9yC82kpwsoK64P3JegGjaDxJOt
CXcqzUlheMGpbmmOKd2m3+OnYCfqkfwQcPaJmLs0danfv1i87XDuYULWHO5+aL8Z
qwk+12DKRZR5lmydHhlPH7R89dCwNgdlbwK6AOmb9hHKaDTB+BoRvtT2VyPcPLwr
GCs0iPcNC3mHJNtRBIIaZ6UnKkWjpiwZL/gg4u3ijX101g+jqMmFfa7zGxb1UScI
TM3itAhvLMR8J1SFXlQNiAugasrHpcZSSlHmN7nJAeo8wG9wO1OTSn61nzLlrOwF
nCVXZTkFXU7hTOfWAKBW
=d1a3
-----END PGP SIGNATURE-----

--=-YctAB83Y4MNxvQCRe/t3--

