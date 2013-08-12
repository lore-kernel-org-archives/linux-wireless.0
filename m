Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:53744 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3HLSH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 14:07:27 -0400
Date: Mon, 12 Aug 2013 20:04:55 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Johan Almbladh <ja@anyfi.net>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add support for split-MAC implementations
Message-ID: <20130812180455.GL849@ritirata.org> (sfid-20130812_200730_705812_3C0CBDC1)
References: <1375968116-24331-1-git-send-email-ja@anyfi.net>
 <1376053671.8355.4.camel@jlt4.sipsolutions.net>
 <CAJWpbEg74C7DYbDkWCpNJRte7X7+40UHgNAL7uWLFHJ64CApKw@mail.gmail.com>
 <CAJWpbEjdHR0HJjPBwSPN0m4kabLWbfV5pWec+9cwbvyWD+AOgg@mail.gmail.com>
 <1376323275.11514.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6J7GEvtanOfV9oXA"
In-Reply-To: <1376323275.11514.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6J7GEvtanOfV9oXA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 06:01:15PM +0200, Johannes Berg wrote:
> On Sun, 2013-08-11 at 22:19 +0200, Johan Almbladh wrote:
> > ieee80211_rx_h_sta_process:
> > The updating of last_rx for an IBSS STA is conditional on the STA
> > being AUTHORIZED. That state is the same regardless of whether the
> > updating is done before or after decryption.
>=20
> That's true, but my concern here was about the reboot problem:
>  * two stations join a secure mesh and communicate
>  * one of them reboots, but quickly rejoins the mesh
> In this case sometimes it gets hard to detect the situation and keeping
> the other station alive. OTOH, it already happens for beacon frames
> which aren't encrypted anyway, so I think it shouldn't matter. Antonio?

For the "reboot detection" mechanism only the beacon and the AUTH frames
are involved, therefore (since both are not encrypted) there should be no
problem.


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--6J7GEvtanOfV9oXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCSPHAAoJEADl0hg6qKeOb0IP/1aUb5JGWl3tQ8GtFCfAh2uu
BzjrefbGdj0iRbBge9sMDkU7wYUdKzreWMDFfT1jdBjdzwsnQxJdk7HpoqYmmOEQ
zdGbCoE0LstxUFeGVbkwt1H5VXnE25ezJKMmynaL6Bg6oR3ZXe/15BwQbA+4guZB
J1G9j04tvVYWOXzkhIc4bqVgmMDXcM93P2c+kaFG1g/PoHUS2CBOx8NjUBSDomOq
ZB2S5f+iXH7gNwfESPOXJCIR0i7OElW0/RNLsUurr9Q+GWZejegNpf9gMFyfC9r6
OaJEHErUUZIGrb4Rmpg9VmggK9xgS75qHWfTHyi2Wov+ohkTPNFDkAK3PwS3Ec0i
ojzC4qYs10vaGm7yES2GC6SF4/DOpmb1Pi5OzpQe4N3mC6TLES/jGhyW9BEv/MW9
Ox/Vk+7MEEM3OIYSYU9naC4dQ6OFIwK1yq4MCEidlufBtOvcJrBMjsSIgqZJ0xju
R5o3Vbd0dLIX2T7wsSLZyXDs+M1LOw7jb8tJ9F1uC1ltArlKfMYK51xZoIdnotT8
XBcYOy89djrosmPSC9ti9jfqHup6L2INzY5PhqKWbM51z7nd8lpC9zknYlUlch3n
9jkPhMyRpNOhtJ8JNymwVl11H/1FH1+pARB1PIEv3jZp35awRDH/JoNacqQT6cxM
KYjrPllOBE5An4/MGhTL
=2J3x
-----END PGP SIGNATURE-----

--6J7GEvtanOfV9oXA--
