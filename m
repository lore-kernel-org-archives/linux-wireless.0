Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbZA2OYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 09:24:19 -0500
Subject: Re: [PATCH resend] crda: rename nl_handle to nl_sock for libnl-2.0
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4980FAB3.9050706@erley.org>
References: <4980EDC8.4050204@erley.org>
	 (sfid-20090129_004437_360979_B9D4728F) <1233187526.16048.95.camel@johannes.local>
	 <4980F67C.70207@erley.org> <1233189164.16048.106.camel@johannes.local>
	 <4980FAB3.9050706@erley.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HinyabmmIMhHwWeScipt"
Date: Thu, 29 Jan 2009 14:37:51 +0100
Message-Id: <1233236271.3912.1.camel@johannes.local> (sfid-20090129_152423_995581_77BB5215)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HinyabmmIMhHwWeScipt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 19:39 -0500, pat-lkml wrote:

> Which leads back around to my question, should I continue pushing
> patches like this your way (after making sure the right patch is on the
> right e-mail with the right description),=20

Heh :) Also make sure your patch isn't line-wrapped next time, please.
The iw resend was line-wrapped.

> or do we want to wait and I'll
> just maintain the patches outside of git, and push them once libnl-2.0
> hits?  On one hand, it makes testing both versions easier, on the other,
> it makes a lot of little 'fix' commits like this.  I have no issues
> maintaining these sorts of patches, but I don't want to do it if you
> don't want them.

No, it's fine, I've committed this now, thanks. I had just thought it
ought to work, based on testing with git snapshot a couple of weeks
ago...

Not that libnl-2.0 compiles cleanly on my system...

johannes

--=-HinyabmmIMhHwWeScipt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgbEsAAoJEKVg1VMiehFYbP8P/j9YAmIWLBDTLmojNK307rFQ
byFoLnNiype8Jm+y3Hvh+9+PO8sfztw5Skkaw3CAojfJJTEZ3GlNg3fiqfvvTspg
jtYhRtGUI+KYDvyoCSnzeBpRSDuLwLfSgrs9syKus4x9JyNnlk4KXYJLCduZS8Zz
doOdSeFLw32Vkn0C25/QslhlgnqBenni5tiksvSDufDo644Fldn1mdTTlB+JWa59
43kG7UxcpXhE0ZFtoIOPrf921G0GXdCFSj3V5hUOsDpAxn5M/PrjXyxXIWVCh5e/
RZRvYI13tQiqTbCwYjcN1tjmVttGF7oFqTki5CPAkEO6RMbGfOwcRc3Y+BDEybA0
xBcN3JY1SUehnm9nh6FH7f2ocG1ZZy/9iFLuMhPxj0OmRZOE3CXbaOM/agBGDNKL
Sj6pKc0Hw3r7hTyizyCmfWX0uvCeL3RWDEv8Ng2M1N0sQ9fLHeecnJt2Mz9Vt78M
mTpYtYbKjxIUllw/yFPuJ5+01WzWijp8aUhPFZz//CWCRsgeY1aw/Kckhx74z9Ge
yuXGCUBDIT9n2WeTkWjdmfTi/sAJe9kXpB1A5jtp7KqP3zxckxLD4gDuyO5fojdZ
nWUAtX/sXjrz3myGvPaYiKqU4ycRe+gYM1EsQQNIJtAnpojYxRqLKG4Sva9k+fwV
2y0ZEXjp1jOC4bSllcck
=Vyy6
-----END PGP SIGNATURE-----

--=-HinyabmmIMhHwWeScipt--

