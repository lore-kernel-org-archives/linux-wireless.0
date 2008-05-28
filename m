Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYE1NQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 09:16:23 -0400
Subject: Re: [PATCH 1/1] mac80211: sends HT IE to user level through wext
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240805272317t359e79d2xb1913779939ac7c9@mail.gmail.com> (sfid-20080528_081713_805729_F618BFC6)
References: <1211907611-27979-1-git-send-email-tomas.winkler@intel.com>
	 <1211907892.3930.19.camel@johannes.berg> <20080527172032.GN4932@jm.kir.nu>
	 <1211909055.3930.23.camel@johannes.berg>
	 <1ba2fa240805272317t359e79d2xb1913779939ac7c9@mail.gmail.com>
	 (sfid-20080528_081713_805729_F618BFC6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QzctC0KeNIbfRjxyegJ0"
Date: Wed, 28 May 2008 15:14:52 +0200
Message-Id: <1211980492.21624.11.camel@johannes.berg> (sfid-20080528_151626_969596_AA2D7B7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QzctC0KeNIbfRjxyegJ0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> I would prefer to get all IEs in one blob (assuming WEXT does not have
> >> length limits on this data that could be up to about 2250 bytes long).

> Would this work with current and older version of  wpa_supplicant?.
> I'm concern with backward compatibility,

Yes, even iwlist handles that fine. In fact, wpa_supplicant simply
concatenates all of them internally, and iwlist just prints each IE it
finds in each GENIE item.

johannes

--=-QzctC0KeNIbfRjxyegJ0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD1ay6Vg1VMiehFYAQKc8Q//RW9c6OLgpagE9gJSoyC4wLdazNdyL6V5
03jSGM6ojPRq2nWp7AIbEnTYa7jPT/gk4OQoj6p5Upr9MPmgvBJmf6ajuxSF7Kf3
yJuTr3+gfhAvMchysDsd4JcRqs7O/OyvspKkaEXfBn+3EiJaeXj1UGrHDjCd3vui
JhK70pkaAC+NlZmeaV0gFIzFiZsJHNNlLZ4KaO6MFoMdoS6QrPLoOmi60G1oM29h
3wk8wYsKOHBmxDYPQ1C+/WTrenOeejdyzAV6uWkBtfqF4rDohqHQvfmONuqmpVeM
3Q2HUc0yS4CsHUBNvHwgWbXMsdcsam9rbUwry0e05hXHXBRoCWM+MMKcsICA+EgQ
m/eDJXNxOuWKLdVd4Cfw9FojnEUlEn9Jh0J4RL0S44Nc0sLRUx5WZe0veK7dd5Vd
z//ptqFmpBDJO22naIEm1Q0/Rts2Vx/BGEitXDzanO13zPHjTwGKS6PTAkqBgDLK
fiovVyZTL5xQ4YBbbNdzjii6VznVaONhedklEcSOpl3CeDufN+SDFHjibsSM0dP8
XgVBox7D9HGQVfKL5QstjKLWwNtoljbMvZ8Upw6IBr3HELGXXI/ke5F78nAyiXQl
ln4yHUCtXLLrVKMt5anc3wTOtXfiRdazzyG+d6J7i5cduyRgk0kd+iQbUK8vjVbn
u7M25y2+wtU=
=L+2A
-----END PGP SIGNATURE-----

--=-QzctC0KeNIbfRjxyegJ0--

