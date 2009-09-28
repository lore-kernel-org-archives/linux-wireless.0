Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbZI1Ol6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 10:41:58 -0400
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890909261657s53b38a2fl7939740fc53dd594@mail.gmail.com>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
	 <3ace41890909241213q5b4992a0sffd4c34a69ac9bb6@mail.gmail.com>
	 <1253859759.3868.569.camel@johannes.local>
	 <3ace41890909250854t3062d1betf89501e5775ccdd0@mail.gmail.com>
	 <1253965154.5122.7.camel@johannes.local>
	 <3ace41890909261657s53b38a2fl7939740fc53dd594@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JAz+REDu2s9FQmah+Qjn"
Date: Mon, 28 Sep 2009 16:41:44 +0200
Message-Id: <1254148904.3151.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JAz+REDu2s9FQmah+Qjn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-09-27 at 00:57 +0100, Hin-Tak Leung wrote:

> I suppose (together with some of the newly added printk you mentioned
> could be removed in the final version) the dmesg messages are somewhat
> confusing, because as a user, I would rather have a deauth message
> that's actually associated with a user action (e.g. if I switch AP or
> rfkill). Is it possible to distinguish situation where a user action
> is involved versus one that isn't? or is the distinction between any
> consequence of 'user-action' vs wpa_supplicant doing-it-on-its-own too
> much buried down in the layers?

Yeah, it'd be nice to avoid that completely. Or even just avoid telling
the driver, maybe with some delay akin iwcommit. Alas, I haven't looked
at it yet and right now it seems to just be a message (and possibly a
deauth frame)

johannes

--=-JAz+REDu2s9FQmah+Qjn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwMskAAoJEODzc/N7+QmaRXoP/iddbBta/DeyJ3tINmFFkLgH
rgKO7z+VwLOHwTK0Ttgbt0TL7DIjd/bNSs6Ixi0Grk/j9xHVFfElBJT2Sh6FE/aq
9JDpEwUqRJmLGUcuxseZvelstcF/kG3GYhxkqZu0jvX2s7xBi4cQZn2TiR8HWgJb
p2C72uwjDY1XBknbrdibgxHCpCPcYfWsO5g8aUurE6RoRINSc4mxKMx5lAhG7Qni
xnrXrmXS+UZw6+HLS6OtDS9mm5pLDHp99wmJ9xvPs/vDULJqxW7p2gTtXv7cRfow
HCxalvYb7eHb0SMVkbeon3exsTnhz9WsH4rMKQa2yzbA3IR11rxScrXEchia16uZ
+Jj9xp5TibelWwkBQAwNaeXwQbbbtvzbLIWWZRqEsrGXpUef0I1HPdxDgwuINtEM
W8QTbOvBSXA9+QXqFw6LnkvSun8IDFxDqTzKrWvoL9JE/zv3f1pMa8PsL1qAxC9+
QqKEDbE+6GlU6HTNjRGNE/hxqGEbydKZgClSYvGSTLXQpWmpJQtrVg1bpscayE9q
B9tHOlZc4r0X4Ru/97ZObUh1XAmmOFCN+JDvbGKVpHnGaBUDT9uSBz2wJ/n2otAh
IO8s+8fGhTKh6HbJYwD13jyuDo4xbZuK5gRf3LUE1FBMjgYmnw1PUkt5OecTI9tT
rKNeIMxxw1Mca6koQdkb
=yUTf
-----END PGP SIGNATURE-----

--=-JAz+REDu2s9FQmah+Qjn--

