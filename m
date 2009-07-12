Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZGLJjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 05:39:01 -0400
Subject: Re: [PATCH v2] mac80211: cancel/restart all timers across
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <m2y6qukjqa.fsf@igel.home>
References: <1242391067.5799.53.camel@johannes.local>
	 <1242553242.10005.76.camel@johannes.local> <m2hbxjky1q.fsf@igel.home>
	 <1247334562.30647.111.camel@johannes.local> <m2ab3bkm2d.fsf@igel.home>
	 <1247345548.30647.116.camel@johannes.local>  <m2y6qukjqa.fsf@igel.home>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-t3AP96DoaOgnSf0gCyjT"
Date: Sun, 12 Jul 2009 11:38:56 +0200
Message-Id: <1247391536.30647.117.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t3AP96DoaOgnSf0gCyjT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-11 at 23:11 +0200, Andreas Schwab wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > Odd, do you get console output before it hangs so you could add printks
> > to figure out where? Jan said that just fixed it for him.
>=20
> Just to clarify, the hanging resume is a different bug.  When applying
> the patch on top of 5bb644a0f both suspend and resume work.

Alright, thanks, that's good to know. I'll submit a fix for this issue
tomorrow, I hope.

johannes

--=-t3AP96DoaOgnSf0gCyjT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKWa8sAAoJEODzc/N7+QmaF64P/0VROLbYokzhisSzlBVO5HXF
IAC76FveJt+SaebU7wvMhoHYL92JXU7tH1eUoPDOipSnKRVGaab8ewFXV5XZJj5o
0tkbLx7KMvNicpwAQ7SapHTZvBBsLVh4ygklA96mX9/8KdaTIiQ2LeYhhsWDQW0E
uCb9+Q+/KV8J9ypXNAWd9paoKCZPrGo+hhcA2P4gYEEnwUww9tIJEooi4hEDbXDg
mQrKU4LtPQpC53pVxLZ46EhRXGOflFBvPJ61MmBFR6aowwhU1cRREW5E2V2y3YWw
6os/qgNWxYbBA+7bun6HMF++9RhfhQE29elmCJ4x+C1QHhVu+VjHsUfu96MVQMlI
gAKPxwFRcQXsMhj5qfU+EKOvhlEwZ1mXb1UiCTFOVzeE2SzxlCxnjBiNuyz0Hs5e
54xY/bflji4+Eb7RmSHwmthXtr+qPZFTckYLDF+N5TTJ6bw5mSgdoLLKrItRFpVx
DRwzxNs5pbubynJevUA2WwuUmCOw0p4dta9L2IuX0el3Q4KPZnui3bSbwG1GL+WQ
3Fb2rXKM5+1dr0AJJ/aRPh8EmBTVa4xsL3uxfrSDlksh9PAvZJh+eaDhCKchJA9z
WnjjTLLtM1Y/CSRtVNc8+zAxIkLeB+rD2P5XTuTZUofdQPp/gUkFzc8InyoDCDGB
MOq5XUbzxAUHmPxFdE4y
=NgPe
-----END PGP SIGNATURE-----

--=-t3AP96DoaOgnSf0gCyjT--

