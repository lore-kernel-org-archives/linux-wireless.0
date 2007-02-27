Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:38876 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751654AbXB0Ppt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 10:45:49 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] d80211: fix sparse warnings
Date: Tue, 27 Feb 2007 10:45:25 -0500
Cc: Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1172530759.3870.205.camel@johannes.berg> <1172539109.5835.28.camel@dv> <200702271640.21252.mb@bu3sch.de>
In-Reply-To: <200702271640.21252.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6671715.tNE7YfPZ4Q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702271045.29797.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6671715.tNE7YfPZ4Q
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 27 February 2007 10:40, Michael Buesch wrote:
> Uh, well.
> I think it's this line, no?
>
> 	control->rts_rateidx = (int)(rate - tx->local->curr_rates);
>
> The problem there is, we have a pointer into an array and we
> need to get the index number into that array.
> Any better way to get an index by a pointer and a basepointer?
I have a patch that reworks the code totally so this is no longer necessary.

-Michael Wu

--nextPart6671715.tNE7YfPZ4Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF5FIZT3Oqt9AH4aERAotHAJ9/wUOh3W0ik8KnXVWfxnQ3Y5SO2gCeLlGu
i8HT1QLOFEGBhmuRucYMfOY=
=hvwL
-----END PGP SIGNATURE-----

--nextPart6671715.tNE7YfPZ4Q--
