Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYB1OyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 09:54:22 -0500
Subject: Re: hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1204190255.3090.165.camel@debian.sh.intel.com>
References: <1204190255.3090.165.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x1fc3fS6aIMgEkNnOjfr"
Date: Thu, 28 Feb 2008 15:54:13 +0100
Message-Id: <1204210453.6309.49.camel@johannes.berg> (sfid-20080228_145441_859146_9DC7EE44)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x1fc3fS6aIMgEkNnOjfr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-02-28 at 17:17 +0800, Zhu Yi wrote:
> Johannes,
>=20
> What's the current state for hostapd and mac80211? I'm using below
> trees. Do I need to apply additional patches from your
> http://johannes.sipsolutions.net/patches/?

Yes, you need at least the one hostapd patch I still have and also the
trivial AP mode enable patch. I'll rebase my patches on the current
wireless-testing tree in a minute so check for patch uploads later than
this email.

> mac80211 from
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-2.6.git;a=
=3Dsummary

As John said, you need -testing.

johannes

--=-x1fc3fS6aIMgEkNnOjfr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8bLFKVg1VMiehFYAQKxhQ/+MB3bL1ejJM1JK9281eHKXeDCP08Y3snF
c9Amk4lyWr79GGrEDuJW/nMyRr80wJXIbZXKLoKu5LlLa4oXe3KyWnRsEo91eLwd
QVE0WtvTVza4kpZh6nFu2eZOgz4xQzqiD+ZGSRccDWhVGMIK1NzmnEVcMFKQMM8C
bBXWWgxCtxFJNvrQfxKVLMkPAf4/fYt/ziHbrPE1QKjPyqKqvAKIScg+qQ1sxnU+
tk0TihFw6WhvWLam5IqcEJWPFmP16ySebp8z3DH9CBuREmaIcWzNx3Z6LsoEqyNT
rBn7RiLttv82VSzNe+q7imn1wXs27lUwEc++2JUspS+W5sjvlGekQM0fl02RBNWN
REYj0CFlF6u8fILtyJxXgR2P1Ngcj3nGNXImJKf3/95xj99TsDhVy8OTY2EdVhqs
DX3SoHjbPpGahTkgfYpLlnae39PrGLK/sCygQRSwwJI5V4MV2QnhP51fWYpUYwzp
1jh2DO8Rbtkks5dR1hQYQzy0UX/aHhn65DQGuDh3GVfnsdTNAYL78bGZrPasRzGE
49brsMeZw0/t9JcSQQDy/1juCjGjjC/tij2wHcEHjJZqG+LQrAwnqCOQaMa8mBfk
gesL7il03Itr6RlTFsaon2me5ihWGZIfq2qLWtiUhSqa2SshsBNe39ZhXo+f/vap
Hy049F4+b6s=
=frf/
-----END PGP SIGNATURE-----

--=-x1fc3fS6aIMgEkNnOjfr--

