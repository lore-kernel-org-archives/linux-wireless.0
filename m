Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZBEWnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 17:43:10 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Dan Williams <dcbw@redhat.com>, Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090205122626.GA19117@jm.kir.nu>
References: <20090204150857.GA5069@sortiz.org>
	 <1233789837.24227.19.camel@localhost.localdomain>
	 <1233790539.7390.23.camel@johannes.local>
	 <20090205084407.GA11126@jm.kir.nu> <20090205111058.GA16422@jm.kir.nu>
	 <1233834907.3931.4.camel@johannes.local> <20090205120730.GA18339@jm.kir.nu>
	 <1233835854.3931.18.camel@johannes.local>
	 <20090205122626.GA19117@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kYg5sL0nUaoDIHcAmy2L"
Date: Thu, 05 Feb 2009 23:42:26 +0100
Message-Id: <1233873746.4101.17.camel@johannes.local> (sfid-20090205_234314_729173_2A6EBE10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kYg5sL0nUaoDIHcAmy2L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-05 at 14:26 +0200, Jouni Malinen wrote:

> It would be somewhat cleaner to truncate between BSSes instead of
> between iw_events, but it would be some more code (remember the length
> before starting to add new BSS and use it if truncations was detected).

Doesn't seem that hard? Want to post the patch for cfg80211?

> I don't think I would bother with custom iw_event stating that
> truncation happened since I do not see much use for it in
> wpa_supplicant. It could be of some use for someone running iwlist scan
> manually.

Yeah, true, no use since you can't get at the other results anyway...
Just use nl80211 :)

johannes

--=-kYg5sL0nUaoDIHcAmy2L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJi2tQAAoJEKVg1VMiehFYCi0QAL5Ue1D743BiK2gocnqOAF9M
7KQ8a7KVsbbegjetjFLJFu8au2VHMYH6aC/MzO+Ltg/bB1X1JF02QTsGD4d128Ls
6gPPLV3yuHY0JDvL/B9EUa0I69Ky12phOwilqxRxQH2bboMsBIRsmxIc4Ay2dann
nl+3MyeP23Oz29zqK6Q6ETkNfw6ZdRkHPUPA9r2CsaM1F1T3Pgbt3Bb200asLeiP
LjNaSQz6yO3bP2Zx4/phRnYRBDPcTekluntAuwA5ZEj7dRDOsNTV/ZVppQBFlvsv
i/DIowGDgYc+kDjIXFv+7xyZjHS3Qvv8wXa8N8IjosGuvfGBgrh+5cayCSjmdJ2I
8g4QCW6qhU0axyY6CU9PqYpLqqRKDn3QdDYg26BO9tX09xHt44ul85J0rp9EXknx
xR8d6oWyEoCEmSNtKNaH54Fq4MLPwTPjlBGCxlzamCDybrBJyeX2uoV/9F8fWp3C
Cgw5Mh5fsaaq1AN1r9h312Uxr814uDS45u50GPmjmJ4fOO935sw4K7QprTVTUjnl
ZSjgTl+Hw9gMfuM747KwcGrD8+F09S301D+7Q5WmoKXunY5VZcApd5FWRMsSwIf/
xfkMqfovudQbK7MVUarKfVPMtGaqQ385QtWaCGB07WpnY6hI+cmRAl04351HI9Ep
zwgK6S1XoamA8EH4xzhl
=meTm
-----END PGP SIGNATURE-----

--=-kYg5sL0nUaoDIHcAmy2L--

