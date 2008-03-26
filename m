Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYCZNDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 09:03:42 -0400
Subject: Re: warning in current tree...
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080325.200320.156846782.davem@davemloft.net> (sfid-20080326_030327_729100_98939B27)
References: <20080325.200320.156846782.davem@davemloft.net>
	 (sfid-20080326_030327_729100_98939B27)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9YYU9MhLG2dAYTR+QASe"
Date: Wed, 26 Mar 2008 14:03:33 +0100
Message-Id: <1206536613.16475.321.camel@johannes.berg> (sfid-20080326_130347_456798_E089F6C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9YYU9MhLG2dAYTR+QASe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-03-25 at 20:03 -0700, David Miller wrote:
> The current net-2.6.26 build warns on allmodconfig because:
>=20
> WARNING: net/wireless/cfg80211: 'ieee80211_get_channel' exported
> twice. Previous exprort was in net/ieee80211/ieee80211.ko

Ahrg. I wasn't aware that had a similarly named function, I'll fix it,
thanks for the note.

johannes

--=-9YYU9MhLG2dAYTR+QASe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+pJo6Vg1VMiehFYAQLEdhAAuOgD40uvi7StonDapaS+Q49olW3v45/t
hw90SkXzLFNSXW43lhQGpQ1+y1en04fBBTi6BnL8fgysL6ZcQCDUJA8qtn1WXz/J
sHxQr/X/YQcXkEaPnN0obW8QMuwnbLcf/ITfpB5PtQxx6R/wPlTsV812maryMjlj
+pUStxUIWTQAupLgrEvYQK9thDp++Mjse9f1c3ZwcQh448/P75iA7KvxJo9d3uRh
7EK1z6JBDYvDHRX2LzZtCOB/zhbsVm1nL6zry+2S04tNqbuBPRM95CF9QyyLb7CE
6rsu+WgZx18c/vyP+l5uW2mUD4oGni7cV1IWeBOkru3M0VahoNGN5yutxK5TBKHl
9nPaby8fwPuQzxMhj0oB8JFYCB5PSq01ilxzitmOIebdf29trCSZtYXiw/S+WPLs
BWFCE65i9MzSdJ3ECkCBe0cvCNQpjLc+54YI46+k2JVviJ8Q5z32jSv6+nYvluh7
2xhHfpuEBhhwFeno/dBlNOZGnGA1RkKPqP4VjT5tJBVG0UI/qniuawSb3227r91k
WbXrThRmQhqa1bk7ptVMKI/f8XiWHk0uxeHWN5RDSFHe8lrrKtUla6BE4MNJ7jqF
M4ZbsEfRybek7l61uCHV+M8l1QmfCsXu4G60SSK9mzIoRVNwL05u2gIEcmg3SaYx
Tf3JqCHzCjA=
=IHZz
-----END PGP SIGNATURE-----

--=-9YYU9MhLG2dAYTR+QASe--

