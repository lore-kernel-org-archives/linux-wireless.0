Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXKIUSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 15:18:30 -0500
Subject: Re: [PATCH 02/14] mac80211: adding 802.11n definitions in
	ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <11945953312850-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oREmindW0j3pnM3HNT08"
Date: Fri, 09 Nov 2007 17:26:41 +0100
Message-Id: <1194625601.4793.119.camel@johannes.berg> (sfid-20071109_201832_787290_556B04A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oREmindW0j3pnM3HNT08
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> +struct ieee80211_bar {

> +struct ieee80211_ht_addt_info {

I'd appreciate comments what the abbreviations mean. I know bar (block
ack request) but not sure about addt (add TS?)

johannes

--=-oREmindW0j3pnM3HNT08
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzSKQKVg1VMiehFYAQKmYg//S/pJdHG4Rgc59WLWCv3mvpCdY4ZWlg9S
HW3ZA23U8BEt4XlCt6seAt7Niw6eaWN9sWRhb+qAjRIdtaSHa0l+nNnRwb2+b4e9
pkmtCeSU7bOFVXTwUzGrxx7O8T6ndsaeAxjGTOff24+cPXXxlddZdTr18Ap6JVw9
Zg1fS10F6XbojzJ3Ttf5GMMvcWMXdnZkQ0r1ew0xmUjA9JTisAZdQdBHeuGEQXHq
4o5OIsxrG8QtmSMxC/a9l5v4c+kd+iojSNJdVJsFQ4QLAacMx6lL3b0DiUErFxlY
F8fZl+WqE8z+Y6uxduXQRFlnuWxx/TljGd/vkSK7gs6/d+aJmO6Adv0SvTrO89SZ
GwFU9sMxZN9lSJf3E/Pr2VGVnZ8c+QtTRQbLu39P6bswtlTv52UYqud4x2AL7Lm3
GaSFIyUrM/FEmCubt32VAsnQ5mhV4AlzVikIStV2H/7MpEtgmXxi7Jxk4MNKAR8g
lbL1K3ui/Ddo2wqEhupl+s9waFurziqiQIda98ZjCuX5Np/X5tM2WKI9lCTpYr0T
itraP2NYYaLbXfy8p3Tl/Ydbst89GVx8sf059i3IxylQ8iHZsPr06w0DsQaQufsR
GMvlKs/7+KIshk054RyxtsQEGChFmllwRYf+gzH0uCw8Nxcp6lUl+f3HNkZhEMtp
rRnsl+UoMEs=
=FeRy
-----END PGP SIGNATURE-----

--=-oREmindW0j3pnM3HNT08--

