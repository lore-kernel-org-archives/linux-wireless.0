Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760222AbYAKV3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 16:29:23 -0500
Subject: Re: [RFC PATCH 07/10] mac80211: A-MPDU Tx change tx_status to
	support Block Ack data
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11999857502772-git-send-email-ron.rindjunsky@intel.com>
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857502772-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WqGDdJFm8SaIbiqonL0Q"
Date: Fri, 11 Jan 2008 17:56:49 +0100
Message-Id: <1200070609.3861.208.camel@johannes.berg> (sfid-20080111_212936_407723_B90881D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WqGDdJFm8SaIbiqonL0Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> + * @ampdu_ack_len: number of aggregated frames.
> + * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
> + * @ampdu_ack_map: block ack bit map for the aggregation.
> + * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.

Can you explain what that bitmap contains?

Broadcom hardware is able to give intermediate status notifications,
would there be any use in those?

johannes

--=-WqGDdJFm8SaIbiqonL0Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4efz6Vg1VMiehFYAQIMsxAAhFxiLIy4LiAzOXcvw4qAA66MzdhvxC7H
IFrrmvv5QT0wCAmdxIl6BTFECLfe+QKmlYX9RdMKXPB2fpvo12ozd469QN1XgVJ8
e6aiQyOcRDZ1Pn+w4B8Ru1EOxTcMM4yCW7S4gwt4Ok/ThQNU3fXS5Vta6byPJftB
wCbScfVpsjtoSzVS0YBzrwAoz2o86AJ0n+fKhAWBUiUyQfeyM+qNzMCe3GMFO7Ym
mnCd4ZQmimUl3uWYTwd/B3+60fv9g9AEBOVtAv/Fja22MoubA6uswh+9hv7VmzQa
horyl3CzYhO6a8zzW7PAckXoH7+LCrLzFv8joqA4TxLqe9SpuXIcCmC6F/kjg/43
UG6FBCLH7g4ISfe9P71EREXJriHC4SnpURq5TQnNa+yJ9hRkeivcVpNVCN7yynMl
Ax9rys4RpJN00McZCXX32fBuzdMgo8a7UQP8ibrqKwyYnpE+gmT8cMTWdunH8jZ3
4eXk11jRuWM5xwhfkjmdtZs9vRJZnSazT6qCo5k6I/L3TN5qiyvUSXBq+lv+XaOU
3ZwqFYJqP9AUEmCkT6Nrq3HS76vrEfjT5WsUkdjALE+7Y5NhVDDG6qEVFHEW51gj
LtxpOmOsFjIQV+8dEgnmw4wKKshEKHxYiVla5q22yP1NRD/Z4oJGnR9W6oqQkdhV
1nFErmG8SH8=
=5NOK
-----END PGP SIGNATURE-----

--=-WqGDdJFm8SaIbiqonL0Q--

