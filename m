Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYJGUGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 16:06:49 -0400
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christoph Hellwig <hch@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240810071301k185eebf6qbca6841af120e0ea@mail.gmail.com> (sfid-20081007_220146_394802_A38B4CB7)
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
	 <200810070821.56462.hs4233@mail.mn-solutions.de>
	 <20081007071529.GA5010@infradead.org> <20081007131615.GR3448@tuxdriver.com>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 <1223408085.3618.2.camel@johannes.berg>
	 <1ba2fa240810071301k185eebf6qbca6841af120e0ea@mail.gmail.com>
	 (sfid-20081007_220146_394802_A38B4CB7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r2ORoJqwTYIZb1jSHJjF"
Date: Tue, 07 Oct 2008 22:06:43 +0200
Message-Id: <1223410003.3618.9.camel@johannes.berg> (sfid-20081007_220653_145606_CE1214DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r2ORoJqwTYIZb1jSHJjF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 22:01 +0200, Tomas Winkler wrote:
> On Tue, Oct 7, 2008 at 9:34 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Tue, 2008-10-07 at 21:28 +0200, Tomas Winkler wrote:
> >
> >> > And please keep the 10 pairs -> 20 addresses, it's a lot easier to
> >> > understand :)
> >
> >> I don't like on this solution two things one is that it 32 bit
> >> variables sits on unaligned address
> >
> > That doesn't matter at all since it's packed, and the bitwise accesses
> > you did previously are way less efficient.
>=20
> This is not packet this is shared memory.

??
The struct is _packed_, nothing to do with packets.

johannes

--=-r2ORoJqwTYIZb1jSHJjF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI68FPAAoJEKVg1VMiehFYmjwQAI9BjIeeFjO5An3DKtbcLvwa
1HaAow0fiBUPsFvY0MMCGEUE3zdse0+6rm/G0bPgOHe+cp6yixNyucb+CarQGMLD
z8Y6B7YWcDBTsU3gdCNkQnuLPP58rN79268sBgoyrnWSD0FAjNb7/JcV2bbY6ZT4
I0qfr8OEs9vkP4yTLTJja5CJUfecRn0iIJ8Q2WOEHYXLqqGkhcv5Nncxexb/WA6U
E2F8IyRFue3JrwgMlL7Fxo6JVwayhW+pgmmLwzS06B7fRBL8ZlzUZKaNR3AFkNXB
tru+y8ZAaW3RbM8HUNqApAk1w58JxuOwoSYMh8NDjjbc47qv7WnsdrSTpo2kcsQd
lguSQSXJPRzQb0pJCne220antSr/3wvJOk0iWelldWdEgCLZKXQG1A3z4lbGr5rU
SAYNZeUuQr6r8/ClAjk6teRM+eZFJr9LnuP1HcV1me53dlwBCYknJjDQnChQSTIa
OvGAf9ppWjn9eK1XBPnLl3WiSAV5FOuPy3Hbi/jBBMpuEIzvZl45W8nBSWpfagY0
91WS2A4E8OqvlwCaX/xCMlfZ3uELSaU7ThvOXSxksKFMlqQ00jrq1zO1Ca/R6+3E
8nrFbrL+QYCdLRyYk/2vXggEtoKvnp+1m637LFfDAQ+p/3yZvsbH+o2WL7T/50rs
P3mICSpC7gm3Wpm5AZQd
=CxOk
-----END PGP SIGNATURE-----

--=-r2ORoJqwTYIZb1jSHJjF--

