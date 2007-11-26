Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbXKZRAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 12:00:21 -0500
Subject: Re: [PATCH 04/15] mac80211: adding 802.11n IEs handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@suse.de>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
In-Reply-To: <jefxyteygc.fsf@sykes.suse.de>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <1196086490284-git-send-email-ron.rindjunsky@intel.com>
	 <1196094586.4149.297.camel@johannes.berg>  <jefxyteygc.fsf@sykes.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NkQkwxVNJq5FU9gVqkNO"
Date: Mon, 26 Nov 2007 18:00:12 +0100
Message-Id: <1196096412.4149.311.camel@johannes.berg> (sfid-20071126_170023_623213_4DE51CB0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NkQkwxVNJq5FU9gVqkNO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > On Mon, 2007-11-26 at 16:14 +0200, Ron Rindjunsky wrote:
> >> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> >> index 9e5b3a9..9caf124 100644
> >> --- a/net/mac80211/ieee80211_i.h
> >> +++ b/net/mac80211/ieee80211_i.h
> >> @@ -89,6 +89,8 @@ struct ieee80211_sta_bss {
> >>  	size_t rsn_ie_len;
> >>  	u8 *wmm_ie;
> >>  	size_t wmm_ie_len;
> >> +	u8 *ht_ie;
> >> +	size_t ht_ie_len;
> >
> > At some point we probably should reorder the fields here to avoid all
> > the padding... Not in this patch though, of course.
>=20
> There should not be any padding, size_t has the same size as a pointer.

Even on 64-bit? In any case, the _len vars can all be u8 too.

johannes

--=-NkQkwxVNJq5FU9gVqkNO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0r7mqVg1VMiehFYAQKCAA/5AWfJbpODHSmc3w/IC+xB2ZpGtkk29gDd
ko5vkDKn5VBrKz+5VwjdOHQI97r6KUuX8fEp1WFCGQY2YBhr9zqtJTaBXaFj8b55
bwVdWVhM3fWWLBcO8bI3TofluHD4EAFb9EE5GqnvTKUrXVzTwx1ggk/3q3ku8/uC
oCvTO/1NWJ8usavST7Fd4bvulxausuJdxfQ3K2R4Oc/aZB4+pZ39Y3SSvjgDCCdq
69K+d4B3/DJ1XQ0qLa6fLNTl1zgy3blkIPtZMJKq7g+EWP70bmQxmlcN5oFX/raN
gUHtIrjpW1I4LlUbF2DSl3i/v5mHgUsz2tt9/ozD3uPilXDQJL1tdafQu944DP+0
lpihDQLnZQ8qLgMCxIx9rn8JqBwn405PuvGljoiGtluMGALOnYyS59HGMFSh7X8z
wysEWXOsKHHKM2P7o/BpzVLyQdvQppl/400lqroExBGoPn7jDCETSf7TOuC5k5u9
vCstSty72UCp4n+Kyfiw/Sp05+lSUOW7fBD462yDoJWom/BYgaCdVrRA7CP59paw
lQ4KcoWeTSh0FEraSl/EMlgiQM+0uMkIkUO8LT6dLdLwutETolanaPMNj+IVreBK
p8kG4uxqaOJUyi1nwDG4MCA41+J6BWdWdZBOHnQIXlaVXg92ll/YjPgBamzwrh3L
i6ShM2/x+A8=
=9pCA
-----END PGP SIGNATURE-----

--=-NkQkwxVNJq5FU9gVqkNO--

