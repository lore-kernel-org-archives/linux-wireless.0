Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYE1OZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 10:25:38 -0400
Subject: Re: [PATCH 1/1] mac80211: sends HT IE to user level through wext
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240805280718u2ee9232ao487575afeb5938f3@mail.gmail.com> (sfid-20080528_161833_598067_D4D64A18)
References: <1211907611-27979-1-git-send-email-tomas.winkler@intel.com>
	 <1211907892.3930.19.camel@johannes.berg> <20080527172032.GN4932@jm.kir.nu>
	 <1211909055.3930.23.camel@johannes.berg>
	 <1ba2fa240805272317t359e79d2xb1913779939ac7c9@mail.gmail.com>
	 <1211980492.21624.11.camel@johannes.berg>
	 <1ba2fa240805280718u2ee9232ao487575afeb5938f3@mail.gmail.com>
	 (sfid-20080528_161833_598067_D4D64A18)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DXzxlLHYYCakWG3HITkm"
Date: Wed, 28 May 2008 16:24:24 +0200
Message-Id: <1211984664.21624.12.camel@johannes.berg> (sfid-20080528_162541_712323_B99062EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DXzxlLHYYCakWG3HITkm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Actually, we do store them in one blob and then hand out pointers to th=
e
> > various parts.
>=20
> we don't store them as one block we allocate each one separately
> (ieee80211_sta_bss) so there will be some bigger rewrite of the code
> than this patch, which I'm a bit reluctant to do...time...bugs etc
> so what more arguments we have to convince me :)

Oh, you're right, I thought we just stored the frame. That might be good
though because right now we kmalloc a whole bunch of things.

Anyway, we can also clean it up later.

johannes

--=-DXzxlLHYYCakWG3HITkm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD1rF6Vg1VMiehFYAQIDvA/+PNbVbGRasNUKqxZF5q7ZhFqb9qBcczcR
LjwAmY+z4ycfi69t6p3RSWTEfkzbYeDkIzjSkhrpU+TLw6HzKboyZ7g+iLfpFuum
49shdpU8OjPjFGIUB6sLucGzqnt0aqK8Dom7BF+vSjV4CZJnHqirTHgHWG/1myKJ
xE6uahyk+X89BXW+K49d05eg4JFeBYZOJ/Cha4c13IynUkbHfC0tvyXrxR6KHD4M
/OL5X+XEYZq9HlPK1sv64j8U5DI06Jerz5dlIS+7NjMyQowdXiLTwXw+pxI/6qG8
+ZwaIoIycNCBPLXnOtsq7FuwJ653CIfZLeuME/XI5Cbk7qzmhjPl21yHWpTOVy8N
JiNccjxSn2DbhW5i2h+r64zrjlgW9SsxNcGayFNtJ48LBqvck68QOdRw9cNCnVt3
J9dUwlHNyVq2vftCmIpCssWOtjihqMG7tg8mXqDIVMlT4nu2ZqB6IktW+44Zod1I
MjOpSlL/SIDZzdgyKtWFUyZLFDz19IflrIo3pgIJIDGvqbHGMS2B/tEHTBGvQFAS
6AD5YMnLkkjiDu/Ts+R3BSQV1UqiGGDhIEwWgIvcWY8C0T85q5rFtTg1EjRn834b
U7Yt5EdzwAbPAZtl3hJylNQlfHFIUj/wxyTDAMCvAUFtA3ikY0G8C7E7+Xd+DPVc
s+Zd+kCHVF4=
=gAyn
-----END PGP SIGNATURE-----

--=-DXzxlLHYYCakWG3HITkm--

