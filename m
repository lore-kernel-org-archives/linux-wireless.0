Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbZCSVlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 17:41:00 -0400
Subject: Re: [PATCH v2 0/6] Use the regulatory bandwidth and export HT40
 stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890903191328j15a53a5au1f0162e53daa2a14@mail.gmail.com> (sfid-20090319_212811_997093_6381103D)
References: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
	 <1237491647.5100.114.camel@johannes.local>
	 <43e72e890903191328j15a53a5au1f0162e53daa2a14@mail.gmail.com>
	 (sfid-20090319_212811_997093_6381103D)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LmCYXqY/F5vjpihpa9U9"
Date: Thu, 19 Mar 2009 22:40:52 +0100
Message-Id: <1237498852.5100.121.camel@johannes.local> (sfid-20090319_224103_000512_E1C35634)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LmCYXqY/F5vjpihpa9U9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 13:28 -0700, Luis R. Rodriguez wrote:
> On Thu, Mar 19, 2009 at 12:40 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > John,
> >
> > please back out this series, I'm not sure I agree with the concept and
> > I'm sure there are potential bugs that can make it segfault.
>=20
> Can you be more elaborate?

reg_process_ht_flags_channel doesn't initialise channel_before and
channel_after.

johannes

--=-LmCYXqY/F5vjpihpa9U9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwrviAAoJEKVg1VMiehFYH48P/jh9ldmRvqW/oGQvN4EDBH2l
vVhqBqWpQCL4Or11+xkvLFnlXFdNpHYz/h1xlENbP3jxZ7B8YddHOZkUu02F71Xe
Jgj2NDZL6iTqTgh+MePLqp6MD7FOZ9a4UXUnUCgV7iIf3MHzo2qWCW7sjt9qFNZM
AtXaZI8lxdPFmymsVrEE/I5aiwUZ8x7X3wPX/JYBvK3r0o8mrV9ol+FdhIZpphwF
skxaSKnN59OwFQwLo4WaKD2weiu2WDnpkVk5Te019+FT3p8+MRk6VGG2jiad/MIp
auaBGmkXvR9SE4ElP6UOr+/k2w4/Ewr1np1nCNZT8egyuvvbhHB24rua2R6PE6XP
6ATS8pnQvdH9zneCV52LpaGpdTJsooFIY5xoaBkyMwkHhXNA3QNXndn6goSdBihY
vxKRJvHYdadFHH4n4bymG6cRQEhwnJX9oWtH1E1JGXW1zf9wmoQR3v+wivkxtZXY
Tu2Ik78jyeDtY9c7a1zSZF7pdA/T8YRhJUhspSOXnz+4dxpgYrg7YV0LlZ+KgbfU
PqfkBXJ77sZNbOEeq325QA0Q4UIhRACyigoNF/1+Elb6hDI7n59CzjlD6oe/+eLA
lbHSzT7T6cm1d2Ff5I22CX5wMvCxxOp/gvbZUd/WrSK7ys5x0a93E1GuwsY/Z6kD
5qpVnZtXBlPNRsZKbnPv
=EBsT
-----END PGP SIGNATURE-----

--=-LmCYXqY/F5vjpihpa9U9--

