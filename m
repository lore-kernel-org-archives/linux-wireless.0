Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbZJaJei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 05:34:38 -0400
Subject: Re: ieee80211_tx_status: headroom too small
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Nikolai ZHUBR <zhubr@mail.ru>, linux-wireless@vger.kernel.org
In-Reply-To: <200910311030.45582.IvDoorn@gmail.com>
References: <1094614475.20091030230028@mail.ru>
	 <200910310959.43260.IvDoorn@gmail.com>
	 <1256981113.3555.92.camel@johannes.local>
	 <200910311030.45582.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aPtc+uC+h/W91h5XtywG"
Date: Sat, 31 Oct 2009 10:34:37 +0100
Message-ID: <1256981677.3555.94.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aPtc+uC+h/W91h5XtywG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 10:30 +0100, Ivo van Doorn wrote:

> > > 4 actually, wasn't there some cases where the header could have an od=
d
> > > number of bytes and would require 3 bytes for alignment?
> >=20
> > Hm, is there? I thought they changed the 11s draft to no longer have
> > that.
>=20
> Well 2 is fine in that case, (I was basing my comment on something said o=
n this mailinglist
> a long time ago). :)

However, it really all depends on the hardware too ... Maybe we should
put more of the logic into drivers, and have mac80211 only export its
required headroom?

Or maybe we should just not bother with having drivers do the alignment
any more -- mac80211 does that now and it only does it if necessary
(i.e. not on powerpc/x86)

johannes

--=-aPtc+uC+h/W91h5XtywG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7ASqAAoJEODzc/N7+QmaousP/RJ3zqDT/IM2phaeXCXDo0NY
+QM5mmY9yZeO9WU2vZgy/MfYt5IBkXfjKaZO+klDlKS21QhlsyklewEnx2AgEIdy
T0PvDykvb64atrlEL15IaRM12TfxGRclF84LaAl0EdPLavdmX7hsjotnipj+4Q4H
sKfS6aDaFokZnfK81RLe6DuCkkWiUj/cc3jCL55HLmkbVwqBOIVcsnRgXlPvCX8i
5iJdHOR4WgTAU6ygWLLWEsi5/kGJab/U6kb4n6UQGldqSu+sSIXWqK7eudrYOf72
4vLbfPUcEp3dhH06So3ia86f0tN2S+0WN1PLF28aDZE1e2TEowX0nMLRolQbF22L
t8o7mY3SP3UGOqOMix1IW+OwifTjvCRSeZxhmAFTsFes/z+wJlRCQ8Cq1A5yOV3r
b5hDBEAuLGbMr6XhlyyCq+j82Pau2MB5MmMabM7j2dM1mfiYBs0LxojxhM1YI61J
CV2+ZkqRvU99bnxyJ7p5arASY8KEVIthgW65SmRaSXA97lFtAbN5TC0kBss0vrvQ
+nz16eHWLbunDj9BITmKK/C7sXQP+L3Fb+9V2daN7J/YOo7+v9SH9nnHxlZm9lNJ
4Us2UfIJVhTwmEtH8CsNoD0Zyf8oyTTs2Gle5KYwlF7W78v9+xQ0s2Y7zQTDtcnR
MFOUGY1H/ZbxxsEnMq9L
=PRrk
-----END PGP SIGNATURE-----

--=-aPtc+uC+h/W91h5XtywG--

