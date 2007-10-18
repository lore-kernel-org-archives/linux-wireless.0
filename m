Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934511AbXJRT2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 15:28:34 -0400
Subject: Re: Rate problems with iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20071018191102.GI10674@kernel.dk> (sfid-20071018_201111_899199_F92BB71F)
References: <20071018191102.GI10674@kernel.dk>
	 (sfid-20071018_201111_899199_F92BB71F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5T/q+0ltUnh/1Lu6Jlbm"
Date: Thu, 18 Oct 2007 21:29:42 +0200
Message-Id: <1192735782.15285.48.camel@johannes.berg> (sfid-20071018_202859_223856_E231FA44)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5T/q+0ltUnh/1Lu6Jlbm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> Copying some files I noticed it was slow, though.

Can you check that the right mode is selected? There's a bugfix pending
for mac80211 that makes it select 802.11b mode rather than 802.11g. I
don't remember whether I've asked this already so if I did please accept
my apology. FWIW, the fix is by me (in all fairness, the regression was
also introduced by me) titled "[PATCH v2] mac80211: fix set_channel
regression"

johannes

--=-5T/q+0ltUnh/1Lu6Jlbm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxe0JaVg1VMiehFYAQK0bw//YyY0VzXUJJXRTx2W5kVokSYWmqAF815x
MskIXypGo04DiCE0XUBrbgDtp/2SJLzh9WpX/5MlZpfoHFJ/3P/DzlQylp7aqogw
EF7bLSqkpNb41M0zkUpOOfLyoumcal3iiX1OrNqn+fcpj3iBYVwf446nO2K7diYb
TWIzFf+IpNnxfbyYjfNE8quVuzZ8khSYw3SFUuu+JQ8o56PBfkJ7bEloyunVpdPF
HbzPDQFp1QD81BoPtb8A0V8O3FGg2xKh9v15FBKiVyYYcbEnTMDbwj6tYvov8O0R
Lrg0hfM6ApociFRQTZmWw+J/Ia2zZEI/gsRHy69E0tPqxs/YlK2A5TJzsAFP+r/z
ePwzyWY7c+s78pnVEmReYZwGaulCIXXtCGLC+4bxcFS6iUL5TMdldpIsbUKBugP8
MAyj5BsAQWRhoVBzV1oDW7pgCB7LtmlrauB6X8nQdV1x63UzQTGNCa3oz1GtOrFb
ZGi6mLrNQFSzU1wqPL2wxVEL69SFrzEpd0kydqW+I7iduDHL3VKQSfsYS468uevE
/w1TLtGUGPYr1pzIdqw1rfKYlE1anZQm1gs9rpwQ/qfDeBnvmqnlkhliy789bvX2
Lh7TJxpXd/OTSYUHwpmSf71b9lx35dOt3T3lJBw8YYTUy8mCDAY2aML3RKQTA1vM
FeJrGZqZex0=
=7ag9
-----END PGP SIGNATURE-----

--=-5T/q+0ltUnh/1Lu6Jlbm--

