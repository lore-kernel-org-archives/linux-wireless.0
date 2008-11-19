Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbYKSOtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 09:49:42 -0500
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
In-Reply-To: <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com> (sfid-20081119_145930_351555_6430D13C)
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com>
	 <1226943608.3902.36.camel@johannes.berg>
	 <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com>
	 (sfid-20081119_145930_351555_6430D13C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7LORQ6Hxk0v3hdW4882c"
Date: Wed, 19 Nov 2008 15:49:06 +0100
Message-Id: <1227106146.26243.43.camel@johannes.berg> (sfid-20081119_154945_736781_A57D5DCE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7LORQ6Hxk0v3hdW4882c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 15:59 +0200, Rami Rosen wrote:

> Two examples:
> 1.1) In the link below it says: "ZD1211 can operate in the mode of
> station and access point."
> http://linux.softpedia.com/get/System/Hardware/ZD1211-Driver-12712.shtml

Maybe it can.

> - Can you please elaborate a bit about how can we know whether a
> device support or does not support multicast buffering ?

I have no idea. At minimum, the driver needs to do what the wiki says:
http://wireless.kernel.org/en/developers/Documentation/mac80211/API
You'll also want to read the 802.11 docs about this.

> - Could it be that some zd1211 chipsets do support multicast
> buffering, and some do not ?

Doubt it, they all use the same firmware.

johannes

--=-7LORQ6Hxk0v3hdW4882c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJCdeAAoJEKVg1VMiehFYxfIP/3jbkWue2ekJKYtk3NN98UE4
PcKPB3YZV32NQ+YZSNj1yUWhxyzxVYPXxHKix8yu0GjbddY3VOxct6nvhsJojuOq
rA2txutmjrjAVmkSLI2A6tkxT2NOE+sPxhoOwISQ3IM1iwH8szn2ve35kYz2tHD1
fP1XQybHMxX74Edqj3tmWjuQBo7ldHOZ4m17GxuX4VhNdvqei4ehIQWXfGM2qWdR
w50kdfn6GN3qprT7jrst2+H9ERicyr0MsACIeVcoY3r3pFhKWD9wCX2bJ0+qVn6o
OHY9HaElw+vul7em259qeoQ/GFTXEj/+Kti4yhNVcKB888hEeFMluSNCkUTXTKiy
bhakgSfCDDTFAuJUk6kJOm5r9k0/K4QOkln7jbEdpMzGTyR43thbz/6znab+59i2
wJB8GfmgJszfz/r1dOpBr7CMlS7Q1sc76G2SJ62/7mD/wf7FwBEFvyio7jOnvJEz
rwoJ0z8RtXKe/884nKbdATuyWxnbIaeCPYCeaiUIvKiMVdn5Q+LbVITDSj/7YrqZ
YxefB2dvtjvyYt+1FRFMq9p7SvOaSeYp0C5d2xzf7ZqoYpwfiLd6hHzjEFVzjlF7
QWNxiRdwIWT2Vq+cxErtJr+4eeyr/WRWdkJ7GH+b3EuciSbTM1z1xnd203jQF+2O
vPWlqmhPlmIZVbKk05HG
=Da73
-----END PGP SIGNATURE-----

--=-7LORQ6Hxk0v3hdW4882c--

