Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761966AbZLLLam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 06:30:42 -0500
Subject: Re: mac80211 noob question
From: Johannes Berg <johannes@sipsolutions.net>
To: VN <vnik5287@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <157c4da70912120329n4b6bc663ic47e95201f7569da@mail.gmail.com>
References: <157c4da70912120218lc53633bk62fc9ee99377a231@mail.gmail.com>
	 <1260613513.2442.319.camel@johannes.local>
	 <157c4da70912120329n4b6bc663ic47e95201f7569da@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9Pq5CCpLs+Vc5AkXzKkW"
Date: Sat, 12 Dec 2009 12:30:45 +0100
Message-ID: <1260617445.2442.332.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9Pq5CCpLs+Vc5AkXzKkW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-12-12 at 22:29 +1100, VN wrote:
> Ah I guess I am. I just assumed that since I'm able to capture data
> frames sent from node A to node B (w/o radiotap?), there should be
> some way to check which ones were acknowledged by node B. Thanks for
> your prompt response!

But are you capturing on A or on B? If you're capturing on A, then yes,
you can figure out whether it was ACKed by B and A received the ACK --
pull up a monitor interface and see the info you get from it.

johannes

--=-9Pq5CCpLs+Vc5AkXzKkW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLI37iAAoJEODzc/N7+QmagLIQAIONUyMIUlaNpxKKRpZ3qgED
DLSVRjGHswimlZvSs7cz+feFfhEiuivqZYbWiWRyT0Xp3Zj80QmNIG306Iip3XGn
dSg82Ova4oSnbC3ONgOj6cirWt3gibJ8SNC8FOdNKPqEGvkDBnGRD9xf1sJkoRRI
JaS0NUn/0huvtd/yDuCxzPOc2qkY1X5u5aaJkCvp8BG2ogxOcNaTteuEbkPw108C
S88uTjZWbVWApG96fzGjwr/y0PA3gtnS9YwB2t8aklsvL3aWZdwlKu2qjZbsO1Nd
wmEreu6Y5BF8PPTX3OnT3ZAT6yloolP0WlTGrkVg5pvBbZEZF96YeV695o0usTE6
JBaRMFWyjndGmkEA0CGsOPo39oEVUBW9Z775Vm4vsF6bs2E3KTDz6r1MFFc94px/
E8go5JBcEBttIgs7mo6LScczyFKBEDNe/Yp4oi1Lv8AajYDp/jIKoaP61FpNNjhe
XMZSxwWbRMGxO+PQiQnK5DWDMWplOi95RZFVoZMt8gINrdk7tZ0O4k34+e8F6MfC
uUT+1bAgcp8tsuDAWiMOA1xYvD//2olqOoPXG/QUBTIpN95e3/D3ixscoRnNUJfw
eOAvTWsToWCLC66WY/EBh+5W+kKWELQPk8mz1EyqAOCIeVH1dk7KBdoc8vJ6P1wM
0mwdcSjOL9SZf+x+fB4t
=3upQ
-----END PGP SIGNATURE-----

--=-9Pq5CCpLs+Vc5AkXzKkW--

