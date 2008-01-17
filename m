Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYARMfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:35:52 -0500
Subject: Re: led support in mac80211 and drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Tomas Carnecky <tom@dbservice.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200801172313.00246.mb@bu3sch.de> (sfid-20080117_221504_214449_91B1F006)
References: <478DF297.9020904@dbservice.com>
	 <20080116200126.GA3164@tuxdriver.com>
	 <1200584782.8007.59.camel@johannes.berg>  <200801172313.00246.mb@bu3sch.de>
	 (sfid-20080117_221504_214449_91B1F006)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w0n5gsNSRzcGs0B1ge98"
Date: Fri, 18 Jan 2008 00:14:45 +0100
Message-Id: <1200611685.8007.69.camel@johannes.berg> (sfid-20080118_123556_504759_58EE555D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w0n5gsNSRzcGs0B1ge98
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I read this thread multiple times, but I don't get where the problem is.
> Why don't you simply implement this in the driver:
> When LED didn't change software state for X jiffies, switch the auto-blin=
king
> LED in the hardware off. Switch it on if it's off in hardware and there's
> a software state transition.
> Where's the problem? This is trivial to implement.

I think the point is that the software LED changes all the time but
that's not necessary for the hardware LED because the firmware will
blink it. Or something like that anyway.

johannes

--=-w0n5gsNSRzcGs0B1ge98
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4/hZKVg1VMiehFYAQJR3Q/8DAOXslJzeVRQm2/tRNQwP5MnP7UfX0le
yo4yBzwI3m3pcMrVp6fGbdlKOC/SzNCom6nQf+8TVabHiGCRPxBa/Ja4FXtNs2Gb
94GAEHQeHdDdvuwymN1pN++3CGi5rAW1grXOHEyhzhwaODjxJjf6+abttcwAq3XT
P2dr4nb/j/vi/EInAd/9QyE0XTBGh0om+0OElS7MhkWC/MNyMr6remOBBhTyg9qQ
OdXwr4fVMknKyhqdNX8uRBGqGhRXzf/q8mLYrJXC6bOU104jrBk8BlVBIs2xsO3a
khHnXW1wZvTKjRCTyKciSq3mRbzzl26V4RNPBpQ566f9dbWOtkyab1lu6g81C+Vh
wvx/yt5+cJ5ZFLZDmCr6bW69P/WtU7RmSsOyBhT8Ezz6Vipe8g7no3taXMmYzNIy
3HC3UWQzCZ2M6cKL4QGo3ZgQukOlLY+W+y349T/0mEJcPADMYzjVr41vrAi+mVXX
i1Pc5XYDz6c0dgJpf1BLo8KLkme3HqOyD9zqcsoAsAqC8yiJ8e0bNMwNDDkMLaxo
c34YG1sP9CtKWFOD4ztDyiAfgYKy5hnJ+QRj/RDznvfAyV/5bWH5jgB7vbVGCgbI
clPJreFg1YRV9UWhr3OtD+d/Ea1hlMfyFTfuZuHe1FDGt749BPCw1FQZiNZMQPll
qA9oyCWZ75I=
=am9n
-----END PGP SIGNATURE-----

--=-w0n5gsNSRzcGs0B1ge98--

