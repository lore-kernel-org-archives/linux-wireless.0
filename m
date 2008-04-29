Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-roam.Stanford.EDU ([171.64.10.152]:57008 "EHLO
	smtp-roam.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbYD2Xar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 19:30:47 -0400
Received: from localhost (SW-90-728-259-1.Stanford.EDU [171.66.159.123])
	(authenticated bits=0)
	by smtp-roam.Stanford.EDU (8.12.11/8.12.11) with ESMTP id m3TNUjvG000693
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2008 16:30:46 -0700
Date: Tue, 29 Apr 2008 16:30:45 -0700
From: Gautam Iyer <gi1242@stanford.edu>
To: linux-wireless@vger.kernel.org
Subject: Re: b43 reduced performance in Linux-2.6.25
Message-ID: <20080429233045.GA26484@stanford.edu> (sfid-20080430_013044_170017_B8678040)
References: <20080429215629.GC17790@stanford.edu> <4817A28E.2050309@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
In-Reply-To: <4817A28E.2050309@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2008 at 05:34:54PM -0500, Larry Finger wrote:

>> I saw a few threads about reduced performance in b43 in the 2.6.24 /
>> 2.6.25_rcXX kernels, but couldn't manage to fix the problem myself:
>> On my system, using ndiswrapper and the windows drivers gives me about
>> 1.5 times the performance of the in kernel b43 drivers.
>> Here are my system specs:
>>     Broadcom Corporation BCM4312 802.11a/b/g [14e4:4312] (rev 02)
>>     Linux 2.6.25 (gentoo-sources-2.6.25-r1).
>>     b43 wireless driver with firmware 410.2160 (2007-05-26 15:32:10)
>> I measured the performance by running "ttcp" between my Laptop and my
>> router. Using b43 on my Laptop gives about 2MB/s reported, and using
>> ndiswrapper gives me about 3MB/s under exactly the same situations.
>> Any ideas about what's going on? (I would be happy to provide you with
>> any further specs on my computer).
>
> Yes. Broadcom wrote the Windows drivers, but never gave the specification=
s=20
> to anyone else. Obvious those specs from their engineers are better than=
=20
> those from the _reverse_ engineers for your card.

Thanks for the explanation! I'm certainly happy that b43 works with good
speeds. Many thanks to you and the other avid hackers that made this
possible...

> On my BCM4311/2 I get better throughput with the b43 driver than I get
> when running Windows. I _NEVER_ use ndiswrapper. Now that b43 works,
> why would I want to taint my kernel?

I don't have Windows so can't compare to it. But even though I use b43
by default, I sometimes have to revert to ndiswrapper on weak signals or
large file transfers. Also ndiswrapper has the power management and
LED's working correctly, which I could not get working with the b43
driver.

> The only specs that we are interested in are those that come from reverse=
=20
> engineering. If you can provide them, we are very interested.

I'll poke around a little with this during Summer. It would certainly
make me a lot happier to use the native b43 drivers than Windows
drivers...

Thanks,

GI

--=20
Will Micro$oft go bankrupt in 1901 because of the Year 2000 Problem?

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgXr6UACgkQ6plSLtsExHE9tQCeKoSqPcvfaTwWFh9whtcGDzCC
b2cAn0mVsUN71ioj1EaRbU5B51h1Rb4/
=4/UC
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
