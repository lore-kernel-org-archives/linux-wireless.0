Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872AbYGOIMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 04:12:33 -0400
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by
	low level driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Tomas Winkler <tomasw@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <87fxqcoaue.fsf@nokia.com>
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	 <1216039127.11189.15.camel@johannes.berg>
	 <1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	 <87fxqcoaue.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XhKPSZR/yVaNh/j5VDay"
Date: Tue, 15 Jul 2008 10:12:23 +0200
Message-Id: <1216109543.23746.21.camel@johannes.berg> (sfid-20080715_101253_271661_EB8B966B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XhKPSZR/yVaNh/j5VDay
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This stuff is very much hardware dependent, I don't deny that, but
> still I would assume that the basic principles are almost the same. We
> just need to come up with a good interface for the drivers. Sure, it's
> more work now, but if we don't do it, PSM support will eventually get
> really messy because all drivers do it somehow differently.

I agree.

> > I really don't know what other vendors do and user should not guess
> > this.
>=20
> Yes, for the user this is too difficult, but I think the driver
> shouldn't be making the decision either. So mac80211 stack would be
> the most logical choice, and it could be make the decisions based on
> user input (or something like that).

Well, the user may want to make a choice based on the latency. Or,
ideally, we would detect that they're using voice and want lower
latency. Or something like that.

johannes

--=-XhKPSZR/yVaNh/j5VDay
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfFvjAAoJEKVg1VMiehFY9n0P/jrTr45BCmoUzggtBYCBfPsC
ill9wPpMI1mqAB4HAqcpvR1kP2axXE26isgMcvByECW5lJ/fNkdFiA4KnnoFNpt3
acWZFTRlX/FMS0/Uj+CB23mUlxYyHYmxtyt5Vng669DmvklsJVhDISxtLxsTX8lB
6hIi8ngk4DZhft/hXAD6b2FzJecPWJcI8wAuWaBVhvVr6QQcgSs04viG0ZCau3Mh
+DYFkzNOtSeLRtuhxctZ6StxNdkO1LaP7vYpHIxnTPX5aLSRhIHtvWS+Iz4rc69u
lkbc1jsrNYcW3mcAi6fW8u/dxrz5kxSpLqtXKDq62Fg+EvWUXduwBu61fVePmDIk
29r5OVhkBe2pXBbaMRnwO6XXsELsLKLlR8I5XIhdrhEhbCZKS5yX2y++xqhUGM9o
kmcJZ9JFtRh5MaMV8RwAaYrWgi+B0VSx0FeisT9ZzL/LZvIGurpYSF8bLv0r1yl/
4+B1DMWBmfpHGo6tqIQBC26FMD83/jYrgdKQeVy5u8pfyFFghX+13OfME41pXeZR
qvVLPMzzesHms9wr9eWGhL3yLDwl+fPFeCK/G9LXD7MgqgANv3CTLLpfTBy/5w0N
QD295bKnCw2Fn8bUJaVUIW6jzCQOsG8AcCcJiVKpPhLBdlPuU0W4e0MYfdJnIQes
Zp5TdynrMtBgaYJ2nzDg
=0rOB
-----END PGP SIGNATURE-----

--=-XhKPSZR/yVaNh/j5VDay--

