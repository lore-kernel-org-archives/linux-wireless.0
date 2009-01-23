Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbZAWWMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:12:03 -0500
Subject: Re: [RFC PATCH v2 0/2] mac80211: ps-poll implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: vivek.natraj@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <87prie8j30.fsf@nokia.com>
References: <20090122114240.31443.18218.stgit@tikku>
	 <1232629209.4224.2.camel@johannes.local>  <87prie8j30.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XhIW4QrvF3nQJRcORsPv"
Date: Fri, 23 Jan 2009 23:11:57 +0100
Message-Id: <1232748717.3977.8.camel@johannes.local> (sfid-20090123_231209_556168_6A6A1E02)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XhIW4QrvF3nQJRcORsPv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 11:31 +0200, Kalle Valo wrote:

> Ok. The problem is that stlc45xx/p54spi requires us to send a null
> frame every time we enable power save and that's causing problems, at
> least that's my current theory. So I need to solve this somehow, I
> need to think this more.

True.

> But can we still apply these patches? Because b43 doesn't support
> power save at all, and ath9k with dynamic power save disabled was
> already broken before my patches, I consider these patches as a step
> forward. And I would like to go forward one small step at a time,
> maintaining huge patches myself until all issues are fixed is quite
> difficult.

Yes, agree, can you repost without RFC and the printk removed (and
possibly rebased)?

johannes

--=-XhIW4QrvF3nQJRcORsPv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJekCrAAoJEKVg1VMiehFYzK8P/0sOxR6bVbvLMIMn/96VSDbw
N0dGZOxWZcIICspFahddm3efzfzpi+O/NSUobO9mQDbU/WkyYOBEyNgfimkd0b3L
hg3mBJ24ANEl7yEtuNd8Ye5z9HpZGEFmmng1zYzQ0jQsVyNOR/S7SIIGtgAx/CFg
PS3CyC/X15Uw8PBm1kFCDUCI1ggfsNwxAlupVJ60S2XOp4xYPU0eOftUm3GDepui
sM/zkzUCVFNBgt6gt8bRJYbucki5otCJEHPWZmHgb/aCS0RcyfjyXiFwQiHsnnth
IMK95mInqcOmskAZeAFa5mIDIb3X1U6AFE5+16K9XI6th8k1vXzpwM56RBjq1VcU
PRN7Lol0jsuG+josq3JGA6orrd4MPf45hO2v3z3gonEFqnBVENnv/jUacnWHANEI
khk4RL8jX7DWov29Sl3U52sXcf9/lnSBSrWjDMOOo+nOWI5/ov4h6DrFqXFLC34x
DS1H4NS/6tw1Yv7Xg0Q24Yc/iIHhL4SgPNmXgVb1+bq3OyKI7G8YwcpkRhy3c33Y
4X9/OnhzYAoD4XxPTr3BNHVUVvrBPTyi1JvyPBjpuiWPziOCGGrMMu34P9hszrcR
r5G6waphh9exWBfORzt8XYFwCz6v4fjQRVh+kMKT2PoC9b1A1RsdZLa64/4sDP0b
XqqsOGhy4MgYWcc33dmi
=jqXb
-----END PGP SIGNATURE-----

--=-XhIW4QrvF3nQJRcORsPv--

