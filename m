Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYISMOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 08:14:38 -0400
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
From: Johannes Berg <johannes@sipsolutions.net>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	LWML <linux-wireless@vger.kernel.org>,
	"Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <20080919115758.GD7222@lenovo> (sfid-20080919_135810_966871_A18CC967)
References: <20080919115758.GD7222@lenovo>
	 (sfid-20080919_135810_966871_A18CC967)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xG5PfX11UmlXEEuvsG44"
Date: Fri, 19 Sep 2008 14:13:57 +0200
Message-Id: <1221826437.10419.86.camel@johannes.berg> (sfid-20080919_141441_628501_7A836778)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xG5PfX11UmlXEEuvsG44
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-19 at 15:57 +0400, Cyrill Gorcunov wrote:
> Interrupt remapping could lead to NULL dereference in case of
> kzalloc failed and memory leak in other way. So fix the
> both cases.

wireless? Wrong mailing list?

johannes

--=-xG5PfX11UmlXEEuvsG44
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI05eCAAoJEKVg1VMiehFYTUsP/i6Deh3KyT3FAxBuI+qMbBKR
kdYDnuUXMl1BuxQxcyi6IeLXdOQ5454fseX0ZYRCeThKTJAiTYX0DTZYViiXvG26
5CJ9b5Zrqp7kvixHtT7Id7UQ8l///7FNN8SIkBdqzwYLpnOlqNKfgVgG50kvoElA
0EKj8K2/YKHtPEuKoc3UgfPwMx0bAHXVaH3VKs9S0bEAt0REvGbfa3VWCse02lCj
C90H+FWHenSmu9RSyp+Xd7rJlJ6jOg5iRhZ+09w9NxqZbe2fJbWJAvUmwhuI/wf1
K+3MXNvDaDppMSwO8gAESiO+PPDkrh0wuhM6uibKxcity6KEkfXioIiQMoN+yF+V
k7EOca6UCo1VqnJjnZVMqPAXfkBUIkEy64BKz810AmCBSmyFyqOEUYpdNvqGiMPp
blWC1b+3jjUfXxqDTVSnNCOHCujiYMkhjeo6Bfa260SAyNsmDOoRkTaOAmf+elRP
6BidgSD74UTuXMloZZt9BgcCm8aMmG2TwVomRxNe+3Xj5ZQ631JHgRpgMZP9TkhM
fRMzZjOGT7xoiapg+3l/Rl9qrGjZwevGxE3LLOwf5/wwww+6BnVIZ4lH//wQWgKn
L/CQSXG/WptCUTQYeIJQQ+L2sDi9ahV35eQCN+yGoGwyPIfGkKC5x4aWnPTEu1T0
V5cmy+CO+7wbdLyJmhLT
=Ubdq
-----END PGP SIGNATURE-----

--=-xG5PfX11UmlXEEuvsG44--

