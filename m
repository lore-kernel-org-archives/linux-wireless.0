Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55101 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXIZMPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 08:15:49 -0400
Subject: Re: A-MSDU deaggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1ba2fa240709260446u2facb62fw1a17af1665b25d03@mail.gmail.com>
References: <1189354526.4506.25.camel@johannes.berg>
	 <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
	 <1190747966.18521.320.camel@johannes.berg>
	 <1ba2fa240709251624ycb516c4t90bcb6846800b18@mail.gmail.com>
	 <1190792394.18521.354.camel@johannes.berg>
	 <1ba2fa240709260446u2facb62fw1a17af1665b25d03@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-598C3j8BURGrScBo6vAz"
Date: Wed, 26 Sep 2007 14:16:55 +0200
Message-Id: <1190809015.4204.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-598C3j8BURGrScBo6vAz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-26 at 13:46 +0200, Tomas Winkler wrote:

> > The only problem I see with not doing this is that hostapd will have to
> > listen for EAPOL frames on all VLAN interfaces but I suppose that is
> > doable.
> >
> I wonder of port control is done for ethernet. 1X is not WLAN invention.
> I'll try to dig it.

I haven't ever seen it, but I'm not sure.

> > > The problem is the order of the handlers.  First you need to
> > > deaggregated the frame then filtered out non EAPLOL frames if the por=
t
> > > is not open.
> >
> > Yeah, I know, I had a plan a while back, will see if I can implement it=
..
> >
> Hope to get there as well in near future.

Ok, let me know what you plan to do. John has pushed the deagg patch
into the "dungeon" branch so it's still there for reference.

johannes

--=-598C3j8BURGrScBo6vAz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+k23/ETPhpq3jKURAlzIAJ9NzX7N3H6Q5NKNApi4uvWTgZRO2ACfc9af
7YKVS7oeEIKv+wGwpOJYhCE=
=y/kY
-----END PGP SIGNATURE-----

--=-598C3j8BURGrScBo6vAz--

