Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXJIJMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 05:12:42 -0400
Subject: Re: [PATCH] mac80211: Defer setting of RX_FLAG_DECRYPTED.
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <1191836094.4063.9.camel@johannes.berg> (sfid-20071008_103427_297564_F26C48FE)
References: <1191767731.8135.5.camel@localhost>
	 (sfid-20071007_153600_904601_06ED94FD)  <1191836094.4063.9.camel@johannes.berg>
	 (sfid-20071008_103427_297564_F26C48FE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ShpxUkM8bczEgb1LDm1k"
Date: Tue, 09 Oct 2007 11:12:54 +0200
Message-Id: <1191921174.4013.2.camel@johannes.berg> (sfid-20071009_101244_664970_AF6FD4FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ShpxUkM8bczEgb1LDm1k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-08 at 11:34 +0200, Johannes Berg wrote:

> Huh. Sorry about that. I had a patch like this initially but then wanted
> to not clutter the code. I think we should instead remove the checks
> from the actual decryption functions though. Mind making a patch for
> that?

Never mind. This looks better since it doesn't require rewriting half
the crypto code.

johannes

--=-ShpxUkM8bczEgb1LDm1k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwtGFaVg1VMiehFYAQJMkxAAwGo9gvKqFs3UYBpurQBQO/m3rrtcVroL
re1+fFGWhz48arbs5eKYXUm5xLLaq+/KQQXlkDik1kYqmpJOIe77yaivTe7JhLn1
Eci+laz+AkGDgzyTi1bg/2U/o3P5dG/PMTN4AP1zG7fdeLn2MoDMDe9gwrkHu+iq
iKTmJVzkOGgQuvYdJ3IU+Quqt6YALH0cO77drVUu9MJw7VJAUL3RVOy3CpBcoZn4
iPd0DHP6WsGbMJdKga+NpG1wX7yreYvQPdP7BRN0e4tYpOfc97NSMz7oz7ymVAUS
z+TNa8nuUNPH81mdwDVEZ2/upfM15ubSf8WF4J0INWmoKBM9DvkaB7O7JpqBFGxk
tvzDSnNf8sxv3cadijHIJ9sGPbpwHaGG6f5dVTgnOwLA/snotikYGKLsS+1cugFU
Zia7EE507BvNq9D5EUyqgmix4DT7Yr+VsIkClG+pksXs+AbjVEq4zKOw2EcodOxN
Ni6MDCKRrKbl0Vo7O90xpjGWfg03zOc1rx1L+wRQ7C3e1P0eL/C3Ql9caRjTHAlG
jlmj0w5p2QCztPwCkGk2H6BJFCJAhSxa6W5/TLZL6FFsxH8Tl4PXofJLo0G5wJXj
GPGMwPw17TZKM3OkcKnbSIGO2yxsJbu8IvRtd4LNhsHiS57wbqDp9h+GCMogKXw4
vKDr6xj0Bkk=
=Gnz+
-----END PGP SIGNATURE-----

--=-ShpxUkM8bczEgb1LDm1k--

