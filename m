Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYABIlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 03:41:39 -0500
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20071231074536.GA26874@infradead.org>
References: <1198253375.16241.76.camel@johannes.berg>
	 <20071230231120.GB16557@uranus.ravnborg.org>
	 <20071231074536.GA26874@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sNszd3ni3H8Zgjt02s6u"
Date: Wed, 02 Jan 2008 09:41:15 +0100
Message-Id: <1199263275.4172.60.camel@johannes.berg> (sfid-20080102_084144_680397_1B2DCFF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sNszd3ni3H8Zgjt02s6u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Why don't we just build the rate control algorithms entirely separate
> useing obj-$(FOO) ?  If they're modular that lets them be their own
> module, and if they're built-in they'll still go into built-in.o.

Yeah. Except that they can't be built-in if mac80211 isn't, and we've
repeatedly had users f' up their installations and bitterly report to us
that mac80211 doesn't work because no rate control algorithm is
available so we wanted to force having one built into mac80211.ko unless
specifically turned off (only with EMBEDDED).

johannes

--=-sNszd3ni3H8Zgjt02s6u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3tOKqVg1VMiehFYAQIOmRAAry73rAB/lkY9pCYNtY6Tz3FL8XwZcwck
4vkkggoI6ao5obuJhYIufyQdiEaACZlvPZ/CwTLF3i4NOwMhCIRz7k1FBN8jyVQ6
NDAWnu0zkYSVqkSWTheP33mBXJfHS65gNVME+3VdILq/K6wy8UVcFXbiNhXwGUvY
Sj/J0rqucwlHqUaTa3OkKfbINlotGueil6mLz/VJUt+Em3s3r0mLc7Gs01Lyx6sS
JL4gpNZq993TXJtvvtPiHBpzzGmGFjOYdsHlvbZi1x1yUyuK02fAggldnZPL55zC
gCtLbnhFAL8D5WAAmPSjMC28egyZWhQgRroHgi/R+uIlhYYO9wu8Mi4Htt+NssqG
rJsL5DTW5xS53m3XMh+OJ44ZHB5inH7vc3lwu4LERRg7dzRNfdgQ+FgwGQGIC/0e
4NXg/jZkUCKSr81MWimcQXE/n0YNdmC3JYe+6YMNGZo2/sD4PXeeuL6xIbqDq20e
IGddwiihPFwMWz/yPCsxED5qgP5K4rq28yO7Ls8x9S2mE5LT46I4cU6I1E30xkQy
uIiIClxoeHpLyCGgS2YcZFgo4NCiergF0u6ZEoxnhAh25wuTcXBIYvFvDu3K4CEF
CfEC2Uzl12Jnjqh4BZJJVyeFW+b/Nf4JuxJsN+3xkBVfiI5TBd/uGelDsZVXld9c
5WjZk20fnsE=
=1owF
-----END PGP SIGNATURE-----

--=-sNszd3ni3H8Zgjt02s6u--

