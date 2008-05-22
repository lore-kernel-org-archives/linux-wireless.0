Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbYEVTW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:22:58 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Pavel Roskin <proski@gnu.org>, Tomas Winkler <tomasw@gmail.com>,
	Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1211483925.28022.23.camel@localhost.localdomain>
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 (sfid-20080522_185359_028598_D17C0097)  <1211478969.3698.56.camel@johannes.berg>
	 <1211481249.28022.15.camel@localhost.localdomain>
	 <1211482203.18709.9.camel@dv>
	 <1211483925.28022.23.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9G90ljoYtGLVBBVy9Ryy"
Date: Thu, 22 May 2008 21:21:32 +0200
Message-Id: <1211484092.3698.73.camel@johannes.berg> (sfid-20080522_212301_463696_428DF52D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9G90ljoYtGLVBBVy9Ryy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I guess the better solution would be to handle A-band channels too.  Is
> there a canonical mapping of channel # to frequency somewhere for the
> A-band stuff?  I put together the following table a while ago from
> googling around which is probably the wrong way to do it, but... my
> sources were mainly wikipedia channel maps for 802.11a and some cisco
> docs from somewhere.

Well if you ignore 802.11j (now merged into 802.11-2007) then it's just
(chan + 1000) * 5.

johannes

--=-9G90ljoYtGLVBBVy9Ryy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDXHu6Vg1VMiehFYAQK4SBAAvIh8UXKIikPYOOo/knk4gJq07Vrif2U4
9XwSvnMhImawGE59dpvGGQnA41XR53dlzdtHUPEdmRxPS1gT/uxgO8d/F6AIo9Vz
NJ9b8fpd+S0paa9oO+V/hJK1jz8T8qE2lmUnVJT9OQJmJfA/BhdHfIlieKDTXuqR
nZspOW5sCwQSuw4lQzZuvFFkUHOBhdObrjH4dkL88pVd6toJY4sSDPWFQU+i8hqJ
ISGXKSs5Mn/WEylW5I5/nSeJh7/3dR3pQECNwKTH1h+Ii7vQGz0CTs/WVa688KfQ
PbiWJTFMDNUP9c7Yo8OaL4Pob20eQrg6A1R+qWd3673Qkm4saCpx/KXhgz1VpQW6
q9dW058ueyIC9/TTLDYa6MeaRCAxmo9n6Qjz66ngDbskkq2Kr2IEVt0W25wlOZAe
D11toihfGsmeVjZZ9d5Olg+WMQEhR5B25lE06MPm3vKrBpqkyY6zbFfeapYpSC/y
YOogrZe4tNoRRrxoCm8R2/sEtj6detm8k+V5ML3yqm6HvWl2CFM48DDipvJW/q7D
8D/xpXOhZ7nWO+ZRTCIJL0PGmAD9rrEi9DU13PX2mgK/AXvlpVIfCemUEUWFPvWa
Lr1QgW3yjD7exZenar1YHEuXWt5ALmWmD/u7hQA0HMJbDU4HjmA3hwXf0Z6zKw4l
XliycJarmGw=
=dQQC
-----END PGP SIGNATURE-----

--=-9G90ljoYtGLVBBVy9Ryy--

