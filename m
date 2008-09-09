Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbYIIJnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 05:43:07 -0400
Subject: Re: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com> (sfid-20080909_114115_700235_A647B926)
References: <1220883730.31304.60.camel@johannes.berg>
	 <48C5868B.8060103@w1.fi> <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 <1220948427.31304.107.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
	 <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com>
	 (sfid-20080909_114115_700235_A647B926)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-556V0AbPBVX5RG0ErC6j"
Date: Tue, 09 Sep 2008 11:42:59 +0200
Message-Id: <1220953379.31304.124.camel@johannes.berg> (sfid-20080909_114331_346251_87BFA8EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-556V0AbPBVX5RG0ErC6j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-09 at 12:41 +0300, Tomas Winkler wrote:

> >> Meaning that other management frames are forward to user space while
> >> BA action frames
> >> are treated inside mac80211.
> >
> > Can you point out where? I don't see it.
> It's should be visible in AP code Yi has posted, unfortunately don't
> have it open right now. Anyhow since then the rx flow has changed a
> lot as you know :) so it has to be reinvented.

Ok, so it's not in the current code and I'm not entirely stupid for not
finding it, heh :) I don't think I even still have the patches on this
box so I won't look.

> >> > Also, I'm not talking about the AP triggering the aggregation sessio=
n,
> >> > this is entirely done with the rate scaling right now, but about an
> >> > associated STA wanting to start an aggregation session. Aren't
> >> > aggregation sessions always triggered by whoever wants to send? So i=
f a
> >> > STA notices it has lots of upload going on it could want to trigger =
a BA
> >> > session, which is something we don't currently support afaict.
> >>
> >> In iwl-agn-rs.c There is not difference if the peer is STA or AP. So
> >> we support this already.
> >
> > Not sure what this has to do with the Intel RS algorithm?
>=20
> Just the trigger for aggregation is implemented there. Otherwise
> nothing special.

Well yes, but that just triggers when aggregation on our end, what I'd
been thinking about was when the remote side wants to start aggregation.

johannes

--=-556V0AbPBVX5RG0ErC6j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxkUfAAoJEKVg1VMiehFY248QAJCmYGlACZBUr3IgQDvHaeH3
yuYyWpzmC/S+L0jMKv4Dhdo43VEBgHoQF4vzOKfVtR1bOitlyfx2qVAGp6qzle7I
OkqKLYPGZngzlrvaUF6W4N5fqN5Tt5VZpUeR1zRIIOon9HfsfpNLEkqtJgQkUNm9
L22DPAnBdRM+dsfeYYwKi74XjJNeA60VjtI3m6dPhcKyvJM/pZssZUX90RX3d0Bc
4lt9qjuiFWnFSdedYmEDYAInBUxgQn0sONvRAVyeBkpOkMnn2XSznypIPx6ZTSsy
XJbqHqBh+Z5sWB/ARwulQ1HLjAz4EjvvJ3o8ge/OHB2ez0B3lBJ/o/A9Ivy2qsMo
5eJ5JRwGCTxI0AOGG5knXFwRc6EZgXxaruKkWTIKZH7qPIfvkOMAK07fHeS57TbO
VeFz6wCfu21oMFgcc2+Ujf2E7lqNBew3RMXPs4dvm7jQjqfE9zMyL5ZoX4F38e23
csGNoPHtjpxINe2h9ioLjv8ZB0SexzPvLOVbTlkrQ42ddMIRRv/soN0DKiQshFxX
4KsjzOqDKLZJs7zWdhgFbax9GD1OMHeZ+8tmpcs5KICB3uhUBc/eJs00sHQaPGcw
ZI469d282C+2uFsXWtfzliGEypTsLrwp7JgJP1DwHXbMtZwTv509ntpmIJ42GZTY
tCcpTb7kau2KuxOT5bzn
=bvuk
-----END PGP SIGNATURE-----

--=-556V0AbPBVX5RG0ErC6j--

