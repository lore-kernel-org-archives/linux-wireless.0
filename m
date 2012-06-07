Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:37385 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab2FGRai (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 13:30:38 -0400
Date: Thu, 7 Jun 2012 19:30:27 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andre Heider <a.heider@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
Message-ID: <20120607193027.05389791@milhouse> (sfid-20120607_193042_423891_C32C6F97)
In-Reply-To: <4FD0E3F3.2060900@lwfinger.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339014959.4523.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	<1339053364.4517.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	<20120607180325.7752b3c0@milhouse>
	<4FD0E3F3.2060900@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/F+8cVG22vrvfzBxJwq_a1x9"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/F+8cVG22vrvfzBxJwq_a1x9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Jun 2012 12:25:07 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> I do not understand what is different about your system than mine.

I think the difference is that he runs opensource firmware, for which the q=
ueuenumber
patching comes into effect. You should be able to reproduce even with stand=
ard
firmware by disabling QOS with the module parameter.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/F+8cVG22vrvfzBxJwq_a1x9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0OUzAAoJEPUyvh2QjYsO8m4P/jil0zQGvfkp1RxbzhDEFkb8
LHJE9LWtvwmjbbJvXLuWMAv0j3TLfidb7Cp94E9LJMRawtgPS6EGeARw2eBz4rll
5G3wsbsvvVyHl8fvPniWwlIM7DsH0apHxrzRVpaGx/eqxXT1wlYdrVLgbh2hQnyM
fLRkm/yKYxWyGnkejNFTUA1+uL0IYSLDbT3RF9e8LfqcUbz2slO1FjgB3HKKJxIz
XC77fC1+w+bl3+PGPZBGZDHNzGzoRSIE/8UOArLgdSWEgwuQsFydAtcjrANAShlW
SLj5n6L+lO97QOPxdJkTAxSfzmjFXPFkhHjA1UUWk3eutFdYJL4QDO1L09Vqe/hj
aaeQS3cogfJd741iEG3FNt6x9dIYNCNJe2Z3ARAzVCA2b7VQ6xDcor/Vfrr8nq+g
eaNc3AK19I6Oubv3r/LXCCF+JvR6n79PatYeE1EYB5iCYMwXfXTZu510rZDiEIBU
9MUZFr1mgDXweddHHo1R10Y9leCIa/yUWm03HcjEGLe+n8ArKzJahpuhh82LjCpC
hYs1RPyHjykHYloXmmIKU6MeBV3iwTIyqGVjeh0ej8BgUXUqq8hdY9AEC1hQ8juO
O2KzOPjMd5A8u/joSxkg654eqqHfljfSguonpZNurVnOc1c43XLuZ6xMT/1JSDke
46Jn4fJWXnFqMoyy41Zt
=yOmC
-----END PGP SIGNATURE-----

--Sig_/F+8cVG22vrvfzBxJwq_a1x9--
