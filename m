Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:19321 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757416AbXJLUoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 16:44:24 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: fix set_channel regression
Date: Fri, 12 Oct 2007 16:41:45 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Marcus Better <marcus@better.se>
References: <fdqhn4$qab$1@sea.gmane.org> <1192216713.4770.58.camel@johannes.berg> <1192217047.4770.61.camel@johannes.berg>
In-Reply-To: <1192217047.4770.61.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1375269.2pAj3StBmm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710121641.49650.flamingice@sourmilk.net> (sfid-20071012_214428_337797_C22D7E5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1375269.2pAj3StBmm
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 12 October 2007 15:24, Johannes Berg wrote:
> Adam Baker reported that the prism2 ioctl removal changed behaviour
> in that now the selection order was the other way around as before.
> New API is planned but not done yet, so for now just use the first
> matching channel in any mode as was previous behaviour with an unset
> next_mode.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Michael Wu <flamingice@sourmilk.net>

Tested and working here.

Thanks,
-Michael Wu

--nextPart1375269.2pAj3StBmm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHD9wNT3Oqt9AH4aERAonGAJ9myPN05ZNdil3zIWLiBXJGtUacrQCfZKJm
pAw9PKMjpFSu6AEZ6Tu4ivw=
=VMIR
-----END PGP SIGNATURE-----

--nextPart1375269.2pAj3StBmm--
