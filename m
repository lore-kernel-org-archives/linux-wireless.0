Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbYKJJxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 04:53:09 -0500
Subject: Re: [RFC 2/2] mac80211: implement dynamic power save
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87myg7zz95.fsf@nokia.com>
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	 <1226245439-30329-3-git-send-email-kalle.valo@nokia.com>
	 <1226309808.4004.16.camel@johannes.berg>  <87myg7zz95.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o0mjtwamlUNjtmICmshf"
Date: Mon, 10 Nov 2008 10:53:13 +0100
Message-Id: <1226310793.4004.18.camel@johannes.berg> (sfid-20081110_105316_635679_59983AF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o0mjtwamlUNjtmICmshf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-10 at 11:49 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > On Sun, 2008-11-09 at 17:43 +0200, Kalle Valo wrote:
> >
> >>  	bool powersave;
> >> +	int dynamic_ps_timeout;
> >> +	struct work_struct ps_enable_work;
> >> +	struct work_struct ps_disable_work;
> >> +	struct timer_list dynamic_ps_timer;
> >
> > I think you could use a delayed work for the enable-work+timer, that
> > combines them already.
>=20
> I was planning to but I didn't find mod_timer() equivalent for
> delayed_work. I need it because I need to cancel the timer all the
> time. Is there similar functionality with delayed_work?

Ah, you're right, that doesn't seem to exist.

johannes

--=-o0mjtwamlUNjtmICmshf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJGASFAAoJEKVg1VMiehFYvuQQAKKOcahZBMV8YlpwG2Huzqv6
HrZc28pSRBV9gpBRFO0wjo6vPVCcYhT2bto2YJX4OP7Um7Hs+rU4IN4vugNM3i+D
dhxVB46aWPhzRcpIf7k3iI4orZhfOWyBsXHCkC3bULAJSvJMWMWJl9/YTlGVr7EK
+U/am7PIngCyvwnFEUKuNjYAsko9ECBqvRLmr76BLoXNN+XbV8lbcnEdeKeIqSWx
PkrkXpPGbhild0U4LOY26hSJZiYFJJeS6mIRvRJ9ryiqJkzeT+YQj1SdogPiBIqS
ChorEsGYRe72WINEb+QALnT/a+CT+QXLkK5PruWMeeSSrTYGTzAgSAu/WuaKXR9o
KEiMeLHnVqvpbvbr85nqNKTDs7d+V7hDMs/HGHF1VRKFbG6iQeB2ArysbkaFZJQz
UP3X9XesML/tuU3qFvvgN+j/pBpahEHk1NGR7iaWV6fsdNUJfQap1Fxtp/GtbL0g
4FsvoAzKHg/vFtSZskaFanYHFUr4yc1jEKxp0jXnqXXyz3dfXYRlKxz9fY0VFRIc
nZHgaUypfOmTYkRcDsCvmaq4c2S3oikFBM3jQAW64m1SJQkbXAxIwCeaJQR+XjAw
83PjrK4pu+pXc2ly/cBweZwD7fSoABI6w68oYTkCWGZVm4kpaGlZ22BuC3+cZsLq
pK5qXesdKxyVWOp3E9IV
=XO0b
-----END PGP SIGNATURE-----

--=-o0mjtwamlUNjtmICmshf--

