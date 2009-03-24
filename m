Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764038AbZCXUYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:24:45 -0400
Subject: Re: [PATCH 0/8] mac80211 aggregation improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090324194847.GC19335@tuxdriver.com>
References: <20090323162834.154525349@sipsolutions.net>
	 <1237883293.6278.9.camel@johannes.local>
	 <43e72e890903240913iee51dcbnfa2409e01d4dd5c0@mail.gmail.com>
	 <20090324194847.GC19335@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SFMcqqoPdlYPDOAtYW/R"
Date: Tue, 24 Mar 2009 21:24:38 +0100
Message-Id: <1237926278.4320.129.camel@johannes.local> (sfid-20090324_212510_376573_7C8CAC25)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SFMcqqoPdlYPDOAtYW/R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 15:48 -0400, John W. Linville wrote:

> > It is not accurate to say Sujith has extensively tested this for
> > ath9k, he probably just ran it a few times. So I cannot say we are as
> > comfortable with the patches as you or Intel seem to be already.

Indeed, both Sujith and I just gave it a few test runs. Given that ath9k
enables aggregation on the first packet always though, the code was
definitely exercised.

> Given Luis's objection I'm inclined to delay.  I have asked
> him to try to "get comfortable" with this patch series over the next
> few days.  If that happens, then I'll try to get this merged during
> the window.

Fair enough.

johannes

--=-SFMcqqoPdlYPDOAtYW/R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyUGEAAoJEKVg1VMiehFYvQIQAINBQ3rcZuQSwcDnklCXrX3z
dX/t/7gohy5pXywWOR/RJ2B0923btx+k1rIaF0CRbf5NI+wF5F9N7kWykvMxFW/l
hkQQ/s2UEkE0WZNR/w4G3lggDYFi7Zf+oNi9lRJ6mojGcxMdLBGqdVl+q7TwLhFA
sBlE9JM8lseWgBM8I+HOwa3f4OTjZM6UGn4iVmPNpmbBfhzSq//QYnqJ0gB0FF5P
VqTrUmM87vD60m/qQ5s32Jtz5EwsfeS/awkbhiNQUVE/3sPJluyyjh0+v+OP8NZp
MG2S5RZPZzGsvRH9wlXPXf1qmakl3/qMEEKPqXbz2KTwUou3yGtH9TGQa1UmFjZD
qHcV2L3u25Z3h8/NXzd1ypKQltENbUx7LIE7vdey8GPpZ4cIb8vfxhBuo2z0l5q0
o8BlLnSuUoEFRxM+zN/328Or7EVs1EbI3IzEDmGQY2Slpuhi8coeiff9HxxkUKG5
U8KKvpOW0Y4K9lHKySl1TbmXjxM7jq+EbUlgh2KIkTCQjJNs2mX7w/WBdPpEEQF4
2CHf/o3FJgzhx2vxscq3jt7z8AOcigpkBxAdaWm7DLq+TGoQ4RTo0rFhryo0Tlfs
2RGCvBe6a8ihEbAXqVplw7DepPLD5ALZaTi57DZZ6RUrs6+sCL4z+qLSl1VHSfRK
y38dCBvQv6NaAj6jC9Xj
=SaOs
-----END PGP SIGNATURE-----

--=-SFMcqqoPdlYPDOAtYW/R--

