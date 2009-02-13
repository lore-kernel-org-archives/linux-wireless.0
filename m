Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZBMG4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 01:56:31 -0500
Subject: Re: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234503363-11014-7-git-send-email-lrodriguez@atheros.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-7-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ca0Msjb2tHKHJl3fnRxV"
Date: Fri, 13 Feb 2009 07:56:27 +0100
Message-Id: <1234508187.1327.19.camel@johannes.local> (sfid-20090213_075634_857464_53BAE057)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ca0Msjb2tHKHJl3fnRxV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 21:36 -0800, Luis R. Rodriguez wrote:
> Driver and userspace regulatory hints are now processed in
> a workqueue. This should fix some lockdep warnings which complain
> about possible circular locking dependencies such as:

Yes, but I need to look at the one Reinette posted and fix that one,
which will probably require a different solution.

johannes

--=-Ca0Msjb2tHKHJl3fnRxV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlRmYAAoJEKVg1VMiehFYqx8P/3km81LtETvXXZtdT4LqoGKv
eURc8cM6Dw7t0mjFbnK8UsT1Ok3z/sSmsXWvJs3KB6DNmwaJvRvgPt7etW20XO9Z
r1uXxqOIIOv1LlcJjJwWNq7PVdAJ/By9y8E1lNIMBsz/slyiPRgvCcwxRQZtWHz4
6L1Xq6Z+OdVLIzrph/DTeuPV6U29PSxRWZeuSFNx8SD7zXf0Ml4YIV+7rhh/f1/0
odcLpjwTx4qyvFlx97L/jxhWMSDmLRUiONNPRcWlxa2YX4v+vKKkQSauADQ99I4Y
3+D66v2Vi7jFVhDQ9HetmCxpLGOnbftWo8qB1HCeR7jHg3L294Bq+SgPFvRmxwJk
JL2mjMOdCiXSWvj36kTbY0kWz6ehr7LHRvDG3LeuPDG8+Z9j0gGawGFR2TxC6ZEs
IVY+24WKdQaKbWfhDJaUawm7vMV2vKvebjYbwfi3WfavJrLmQy7icTVPwTOHgGes
bWi4HoHxjmuxI0K1PsZdBNc+QWgD7egdPJYRWrTCl2cp5Mb/qabyFu7dQ0KbI9DQ
arnoO3KUsfjIrBx2lbMs7UchR+WuF8souVMBcjbHmtqxp7G8I9Oe9BAzkYkXwMDu
wM53cVyXBybBHrbhYPYQPrc9bvfCck/gKbbEG4mdvyvj/gM+bZQMF8x3KW9rIb4y
fI2DZGR3MtniCdR2yxqd
=ohgQ
-----END PGP SIGNATURE-----

--=-Ca0Msjb2tHKHJl3fnRxV--

