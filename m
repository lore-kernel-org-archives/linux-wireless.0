Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbYFYKmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 06:42:49 -0400
Subject: Re: Broken fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806250335g7251fe9ax5a470990357f0b71@mail.gmail.com> (sfid-20080625_123529_945498_B438D1F6)
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213889200.8967.26.camel@johannes.berg>
	 <1ba2fa240806191113nd6a221eiac9648edd3404a80@mail.gmail.com>
	 <1213899419.8967.59.camel@johannes.berg>
	 <1ba2fa240806191409k7200ad53y654a7f8a117c8f14@mail.gmail.com>
	 <1213910734.8967.117.camel@johannes.berg>
	 <1ba2fa240806250250k2ae66eddre00172f6bc871fcb@mail.gmail.com>
	 <1214388133.21847.8.camel@johannes.berg>
	 <1ba2fa240806250330s15168d22i50e61498fbba6af7@mail.gmail.com>
	 <1214389930.21847.12.camel@johannes.berg>
	 <1ba2fa240806250335g7251fe9ax5a470990357f0b71@mail.gmail.com>
	 (sfid-20080625_123529_945498_B438D1F6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/mDuM40urnSpH9GEVRnL"
Date: Wed, 25 Jun 2008 12:42:08 +0200
Message-Id: <1214390528.21847.15.camel@johannes.berg> (sfid-20080625_124252_650441_94B28411)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/mDuM40urnSpH9GEVRnL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-25 at 13:35 +0300, Tomas Winkler wrote:
> On Wed, Jun 25, 2008 at 1:32 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2008-06-25 at 13:30 +0300, Tomas Winkler wrote:
> >
> >> >> So the bug is still in mac80211. Fragments are scheduled to differe=
nt
> >> >> TIDs and hence to different queues.
> >> >> Investigating further. If you have something in mind let me know
> >> >
> >> > Hmm, yes, I do indeed, try
> >> >
> >> > skb_copy_queue_mapping(frag, first);
> >> >
> >> > where you previously added the cb copy.
> >
> >> Yeah just found that too 2 min ago :)
> >
> > :)
> >
> > Before it happens again, can you think of anything else we need to copy=
?
>=20
> Not sure, now it works.
> Shell I send a patch or blend it into the original one.

I don't care, ask John? Or just merge them, he doesn't seem to have
merged it yet.

johannes

--=-/mDuM40urnSpH9GEVRnL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYiD9AAoJEKVg1VMiehFYqp0P/i1Vfzp2YqXLVQ+xUHWRDdyB
DziPZg9FBu3kduJT8BqINKjWNvQWovHqZGMs968abChmci0Wmkv/XjZir5zKT4+v
2jsZ7Tgo6Z+eX+44FBOCesfz6RTOPcytRtYQFnwjcAkCPO8uFh10ddl1svE8dNp/
2zTM4sWite34uRL4cDK/YEUlduhtuKI4p0GqtnRvhpAOLaPsFt1mRfzRuOr2N30N
FQ6679JkB3GvuKt14t8Ch6dbA7sO0wquqCCRf7nRMkdOLUS3rFoop0pm1dh7+YV2
Kxar1wWNVS6Y/OMsTN78jPMqa7SeFcMBKlh3eeEN5d6U3dg9L7w8c9Ok1YeVdFc4
CbXdsWskpYMSl5ZIUbGKq0aR4a3pSF/VUXuncaP7beUnbOs4x5e2fKYsgUuqTW8m
rARJLuI86eDp6MNNSoOFd5JRQsdnMgJHA13FqD/u08+OInps032CbZj8+h8jCk7t
q7+OERU4aP75xSfsU5N2jDVS0sQeEyFz58+tXr5wAFfn/NmvWhXGJqD+n35XWiu9
P+Wvt4uy/DLZ6zV2dQ/Up62tkFEzG7RpBjSSjAOzNnZnBQlj+ncry96osrPtt1ZK
bmlYMLw+bvg9F1drac5TJFxeGkHFWSlUHmn2lrqy1ImDxSTRznwd2H2QT0e6e5Tf
sDV+G+eZa8driXnR6UqI
=8VOy
-----END PGP SIGNATURE-----

--=-/mDuM40urnSpH9GEVRnL--

