Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLVKWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 05:22:23 -0500
Subject: Re: drivers supporting AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <8999a3120712211800l29abd40n66ad9abab56390db@mail.gmail.com> (sfid-20071222_020214_179423_4027F42F)
References: <8999a3120712211602r43d9c568naa09efcd7f410b2f@mail.gmail.com>
	 <1198282353.6630.1.camel@johannes.berg>
	 <8999a3120712211800l29abd40n66ad9abab56390db@mail.gmail.com>
	 (sfid-20071222_020214_179423_4027F42F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-698BB5yd71+fXRqupudc"
Date: Sat, 22 Dec 2007 11:22:10 +0100
Message-Id: <1198318931.6630.3.camel@johannes.berg> (sfid-20071222_102229_869235_CBE9DC97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-698BB5yd71+fXRqupudc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Ok, without hostapd I should still be able to setup an unencrypted AP, ri=
ght?

No. You need hostapd anyway to manage the stations etc., we're not going
to put that into the kernel. See my [FYI] mails on the topic.

> With regard to driver choices, it looks like the b43 is the way to go
> if I wanted to setup something that currently works.

Certainly it'll be the first one to work since I'm actively working on
that.

johannes

--=-698BB5yd71+fXRqupudc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2zlUaVg1VMiehFYAQJOxQ//VfaCgQkCt8B7vTuTARm9kqx4IEYo9x7S
r9JQrjpHSWn5BbOIoLhAOSXpfqPk9++g7yPXLunuooavRoHqHqVTTgBpLrxbKJbt
wXsleo0JZRc6CT2GUSE6ZJ+duvBQMt54WCkxGf3sDaxT0iZzZFGUaWT4B7NvrgL7
EqOynPG0ICcs+O6aPQcaKlrwwu+mU0VCQR+Es9YxzCueR+9L5qdk4UuuQb+fUJd6
nQRc01VoGM5Gbc0g+N4ZLIsy4hIRnakN67/qH4QTZxEYiF+VyotcdlM4fRxXHmYB
T9OM3SHrJHjhFsxpGPo3TxXf6nmbt3HD+fc6e1n21RdNQJtRK2bw7tyDK5HW9IFB
Lzwm8jn9dJXkzdQvJi8Og8qVptZ1wBI6k9vgwSzJJSWAZU17/4H6kUBdyn+OcVb6
f4TcZsdcTHvOurLiA/oFAlKg/SSMtEKrwnR901h3vfFwBJLKf+8s86I6oESPoXh+
ghBYIGW3KSdpZs/7VDzjqpYp4AGA8P7APhu22pKYMko/+FjtMmejsc++OvQqJopd
x5FsssJr2ECAjFAZmbhQcWPaEzaE/2h2L8136ATvkxn5Yxx30YsMXJI0XE41NHcs
zrqgbiRkW/o1BLoTYX5+AfATPFe+sbd1AiCm/Afd9vLxVu2O6jEeLl/KXjCkX2EZ
LANRA3VyqDA=
=jIsv
-----END PGP SIGNATURE-----

--=-698BB5yd71+fXRqupudc--

