Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZBEVLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 16:11:33 -0500
Subject: Re: [PATCH] cfg80211/nl80211: scanning (and mac80211 update to use
	it)
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1233865700.4101.6.camel@johannes.local> (sfid-20090205_212948_242875_7FE858B1)
References: <1233865700.4101.6.camel@johannes.local>
	 (sfid-20090205_212948_242875_7FE858B1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VKHMO0wnjQPLqlOAzaUV"
Date: Thu, 05 Feb 2009 22:10:55 +0100
Message-Id: <1233868255.4101.8.camel@johannes.local> (sfid-20090205_221137_040646_ADC5262D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VKHMO0wnjQPLqlOAzaUV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Tested, FYI:

# iw dev wlan2 scan dump|grep SSID|wc -l
1063

johannes

--=-VKHMO0wnjQPLqlOAzaUV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJi1XcAAoJEKVg1VMiehFYkS8P/RhBuvJyd5bT1BK5rTKGD7Ac
UnxFoBkpCxjWMUWi9zwDRwlspEfpCkLT4ZxWkwLTxm7VIJNZYxC/i8jRd71d+Ifr
+hr/Wr2/c5lbtKFDPv00aFSbE6a4nvx4CNaacFc3xcWY381eWMJsL3Qiq3weZVwp
O9GAMtwCZ9nwsPeATLpu23UHSptzrUEycignoULSXmg+f6MAhcfYocuGG51/mP9A
1XFDkEl/LnJ5NqY4Wf/SbA+7KKPkOAS/xbR37W1kClkoIwLkPx/z9X0t8Zgr8wa/
fPJn5Awm7pVp3Jsjbxlz8BfjNmNElRPrVjshyDNvDgGByPZg1mh3a/BAldBpBvje
T9XqNp8xdx+vV0lQ3iC8ivjYhoxYe37wwuusit6QnstExzTZBvSG4Gn0jVJquHwf
KaVn+M2GEUf3rVQ/d0MluPXiJa+kLEN/HOBQXhdqWMU+/O3gCho9CvRJd2Qn3Hqc
HXv6gDFd7ozjAHaJrRpwwTfE9ztAm1P7SWqf/BwXtcfJfl3WzS/qlp4Btddesdeg
yQdUfAcvwV8UpJxA/JYarD2tBn9Vz0w5QqVv6HG498EP+CuSZeeipb4MhIHDuIZO
7jHKjrzy7MNsY8J4nmGHRcodZaALaMK6Kg3zOm9unS3uV4+5JjeUalimEUFTb0jv
kBDb7nyTdQE1bu/jRsCz
=blIG
-----END PGP SIGNATURE-----

--=-VKHMO0wnjQPLqlOAzaUV--

