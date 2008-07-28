Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54223 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYG1Otl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 10:49:41 -0400
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Dan Williams <dcbw@redhat.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807280744r5ea8c58aqf53cc99abb4cf084@mail.gmail.com> (sfid-20080728_164417_087826_D8B5C59D)
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de>
	 <1217253465.28198.20.camel@localhost.localdomain>
	 <200807281625.58188.mb@bu3sch.de>
	 <1ba2fa240807280744r5ea8c58aqf53cc99abb4cf084@mail.gmail.com>
	 (sfid-20080728_164417_087826_D8B5C59D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1/iKUnUEBZnGzuTGgcvT"
Date: Mon, 28 Jul 2008 16:49:25 +0200
Message-Id: <1217256565.15381.0.camel@johannes.berg> (sfid-20080728_164946_606826_7842A34C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1/iKUnUEBZnGzuTGgcvT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-28 at 17:44 +0300, Tomas Winkler wrote:
> On Mon, Jul 28, 2008 at 5:25 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Monday 28 July 2008 15:57:45 Dan Williams wrote:
> >> > (What are the udev problems, btw?)
> >>
> >> People seem to want persistent device names.  Since the kernel doesn't
> >> provide stable device/bus enumeration, there are udev hacks (see
> >> attached from Fedora 9) that read the MAC address of the card on
> >> hot-plug and then assign it to a cached device name so that every time=
 I
> >> plug in my Netgear MA401 it gets "eth2".
> >
> > Yeah well. But using a pseudo-random MAC as a base to build a persisten=
t
> > naming scheme on sounds pretty fragile to me. ;)
> >
> > I think cards that don't supply MAC early simply cannot support
> > a really working persistent naming scheme well. udev should probably
> > just enumerate eth0 - ethX as it sees the devices. That's as good
> > as mixing a numbering scheme into a pseudo MAC, IMO. And it's
> > less confusing and it pushes a lot of policy decisions into userspace.
>=20
> Can devices supply something depending on its bus numbering that will
> not change unless it's plugged out.

Doesn't even need to provide it, udev can look at all that info if it
wants.

johannes

--=-1/iKUnUEBZnGzuTGgcvT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjdxxAAoJEKVg1VMiehFYYGIP/0kD+vimUp8wIQBYwmBUsFz1
0QSIlaqKKbQmBH39dZAY6Ppyxx2uQhFMiAYLS1grju1StbApV/A/N76zDKdDO2jJ
99qeZU0cJ1ntStxIz8XdrPjSFq/cer9OgfzBfdsEmSUdsZ0QvkFtdFKcYIRj3khh
G/NwOuJVutz9bdgpTJ9EUNzcs14PLN6tQPeJuK8m4TJ6Xe8XNIJvE/K3C4h8LRf/
qafnlv8KV5xbrLm3Qj/SRWJLUFm8/e6f4mVhhMynWNlIfxl3tKNZn84YhQFXhRph
Ey2iGYilzQ3UrYHIS29NJN4o6q/KkKlr8fTTeO8Vc7mNfF8noKL/5TrIG33UWo9t
S3FQdcLtQIIivJ+nKkxB2lQYCQDcmEK9IvKRDAhgRrnz12GXJxOc0GsK9aoA6/aT
+DkFw8DGnI4ABRt/dHsoTAZEfKLt4Ov3BL2HG6G/vnYy/S01HnCVd9llDjUQB5PZ
M2AQLZMyhtL0aFbuOvVwtFExllDNDDiOKLAykot+frqXzpwte9wMw0F6IMAEzKYS
c96A71+rJd1L0ErFXxwjrUCtylG4bl2KNYQyuCZ3uerTybRbI5MxWcKILHCW6zOX
y4/7HRiQatg9ANnks3B0NAvAZuWLOZLZLOHP1jk4GSX8Zdv8HCN7UdbEDev6NCVt
S7SIC6WSKGhaO9sdj78s
=ExFD
-----END PGP SIGNATURE-----

--=-1/iKUnUEBZnGzuTGgcvT--

