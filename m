Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbXLQSJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 13:09:08 -0500
Subject: Re: [PATCH 4/8] mac80211: A-MPDU Rx MLME data initialization
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11979070784033-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070784033-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FzTqix0HtePUj66/AX/Y"
Date: Mon, 17 Dec 2007 19:09:03 +0100
Message-Id: <1197914943.4885.78.camel@johannes.berg> (sfid-20071217_180912_652090_5C25FAA3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FzTqix0HtePUj66/AX/Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	spin_lock_init(&sta->ampdu_mlme.ampdu_rx);
> +	for (i =3D 0; i < STA_TID_NUM; i++) {
> +		sta->timer_to_tid[i] =3D i;

Please add a comment here as well that this *must* be initialised to the
identity mapping and have the comment mention the user(s).

johannes

--=-FzTqix0HtePUj66/AX/Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2a7PqVg1VMiehFYAQLStg//bc+1lYa2L0gvnbhtEkZIeRjVl/PUg/P+
5D0tR2MuDHtnRmmgBe9mlXOACBzAx0OvzJJJxmli3Qbp/W7lX/UWYvJY9U5B3CA9
86zOvXTG6lLT1jVszwFWMNa7V+EV03PTlwwZqzQrnmmzzZTQMVBqBaDecbH2bkvH
KeFwksmbDXZW1vFv6fVG7aYOOorOW4ZCNTkYA775vK2AqG6Cx1AgDdowsZ9P8m3M
j+TE4nm9+Cle3+L//fnpCI+biAWzWx2UgX6VAzAqDAxQvin4G4CKurdehzvOuwmC
7eAihVwMHCBba9scWkm6TnNP4pnc6BzuaiKLPH0yu/9/ZMNqDWifmVY/vbjW0LpA
SsXDBK0pgcQKnjzDcmakaapozLGvTLMw6m+s9uvoOsEUiM/rH5hK7Lb949Mjjs40
07UeOu2subC6Un3o1aqo55mBa03mP4hHKhLCzMokmT8OwkrbbbakVW9ushPvG/rP
jscZsuulG32ByyattxQzsAkc742l/kqtbdIZRDYyMm+X5/HHqSFDayUFMDxdATzu
mmK/cb2LP4PrLZHoDYoLGYcVMRuQRxpMph4IfKE/eNVQZHMzKemGt5r/89C2us/w
Yh8xOhPmm5I1nLKrNRuRMp2WusoAsbnpPd6khqUv3lbi7bI+Wyym3fGKjjNIT2Tu
tgi3Ypych50=
=g1nk
-----END PGP SIGNATURE-----

--=-FzTqix0HtePUj66/AX/Y--

