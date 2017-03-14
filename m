Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38567 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752549AbdCNOV3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 10:21:29 -0400
Received: by mail-wm0-f44.google.com with SMTP id t189so232687wmt.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 07:21:23 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@openmesh.com>,
        linux-wireless@vger.kernel.org,
        Benjamin Berg <benjamin@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Allow multiple listeners for management frames.
Date: Tue, 14 Mar 2017 15:21:17 +0100
Message-ID: <2459952.Zo1p5FTnYy@bentobox> (sfid-20170314_152541_311198_327F51D4)
In-Reply-To: <1489500792.10872.13.camel@sipsolutions.net>
References: <20170310093454.27664-1-sven.eckelmann@openmesh.com> <3029516.gVNlmVZjU3@prime> <1489500792.10872.13.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6772490.N65mIeIQhg"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6772490.N65mIeIQhg
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Dienstag, 14. M=E4rz 2017 15:13:12 CET Johannes Berg wrote:
> > The idea was to grab probe requests from userspace with a program
> > running next to hostapd.
>=20
> I guess there are some efficiency problems with that right now, but a
> monitor mode interface should work just as well. Perhaps we can allow
> attaching a BPF program to a monitor mode interface, and run that
> without cloning the SKB etc.?

This has also other problems. For example the ath10k fw will crash a lot
when a monitor interface is active. I think that we saw also some
performance regressions caused by the ath9k filtering behavior when a
monitor mode interface is active (without actually listening on it).

Kind regards,
	Sven
--nextPart6772490.N65mIeIQhg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAljH/F0ACgkQXYcKB8Em
e0ZSUA/9GkJysOsullW+Xv18uE96jutaRp5o92lAwdVYqSlhH7sCBqDilrNZAySQ
LLm/k42M2WvpBdYP3t97N0+Fx6gW1CmcYfB6x/T4zsk6HPC1q0lNytNl1TZQjMvH
1WVFu4rulc3W7ZlGssh8t12PHrJBScgG7XxDGDJeimlkjYjzv1M3biFgXcOEwBkI
tW8uoKS+WGnBy54eImkaFEV68mrxTqEjsrOUOjNdbv/dCXPQ2Yqd/np1ugdMXAzH
bR4kwFCa/k28Rjk0DBHA9JzKSHrMcnoCRsZd5c2aL5OmtgM0yLBJiOD7Qz567+bW
jXRA0g8ae8Zu//UD4Z++P8ODw76D0+SyvkE4RsKf3Uc/UY9PhpAgU1G97Mceqzmb
9IaYtS2hMXbAQSzLIuRPAsCoT0n9t2DI2Zv6R0UWxLndY/QVPvPiQmu/crwRSOgo
xHM4YWFnLKWIMM5dhwvzBvRet82T8aj96ckVi8p33GJK/DIXsB95zaViTpC+AZrR
LP1fetFQtRMO8WRxyRgE+ioNiH+QVasK7ihHPsdcWcU9rYFKsNG566TpYmePW4X+
Y0TZScyuNJnJIaSbcZQublrFwLZqs918RdxBHZZKoLvmmjnVmmRcwogntoXIw4Yx
wFrNwMB41S9hU0nPG0e29kIYJy48dsEdDvVz62p+l2ykWmFxs+c=
=rRL2
-----END PGP SIGNATURE-----

--nextPart6772490.N65mIeIQhg--
