Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:62434 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030395AbXBOTDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 14:03:19 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Date: Thu, 15 Feb 2007 14:02:43 -0500
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702141423.27823.IvDoorn@gmail.com> <1171557724.5220.30.camel@johannes.berg>
In-Reply-To: <1171557724.5220.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart50940810.pY0eN49rWj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702151402.48150.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart50940810.pY0eN49rWj
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 15 February 2007 11:42, Johannes Berg wrote:
> On Wed, 2007-02-14 at 14:23 +0100, Ivo van Doorn wrote:
> > Most hardware can keep track of sequence numbers themselves,
> > unfortunately *most* doesn't cover all devices. ;)
> > This patch will keep track of the (per-bss) sequence number
> > if the flag IEEE80211_HW_SOFTWARE_SEQUENCE has been set.
>
> Can this be a library function instead? Our TX path is already cluttered
> enough...
>
If we're going to switch to a library approach, let's do it all at once. I=
=20
don't want some features requiring flags to toggle and others requiring a=20
function to call.

=2DMichael Wu

--nextPart50940810.pY0eN49rWj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF1K5YT3Oqt9AH4aERAkD9AJwOvajqDB74lP+9x634TS0Hq7TlIACcD3ex
OYgfMHXSHOP1VRJ/l+x6uzg=
=TYx/
-----END PGP SIGNATURE-----

--nextPart50940810.pY0eN49rWj--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
