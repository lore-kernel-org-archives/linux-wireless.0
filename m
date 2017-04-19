Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:60098 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759598AbdDSG4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 02:56:34 -0400
Date: Wed, 19 Apr 2017 08:56:32 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: ks7010 endianness question
Message-ID: <20170419065632.GB1432@katana> (sfid-20170419_085638_049021_B5AA2604)
References: <20170419033446.GA17058@eros>
 <20170419040258.GB17058@eros>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
In-Reply-To: <20170419040258.GB17058@eros>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I think we can call this question resolved. Remove the comment and
> change the hostif_hdr description to
>=20
> struct hostif_hdr {
> 	__be16 size;
>  	__be16 event;
> } __packed;
>=20
> Are you happy with this?

Yes, I trust you.


--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJY9wogAAoJEBQN5MwUoCm2egUP+wR7CPQzJlSMdKYOrlOQN7FT
qiFcqu7ENI5DhpLjx2P1yJLpDbjov6zP84zUPKQca8sNtn4n/gQdUWLFnfoVPqj3
QwafjBClnqPxWVDu394gw8QxM2T09a+tzvkILyBU16FabO8dkiief5EJQKQ4jGda
79fpOeCAUUI51G6LhJCileqxpPlectfIfHXqDZZNN/uCn3sNi3MMYX89mX0yWpVr
u6q9sqnWxYjTTSxS8/ed3QSuCpJXqvtXSz71ozHsUoiNHQeImc4NfnKsijDfBR8/
IUD0+G2GTVEO3IHRt6NoAxJlBkoWWwt7IXNTHDTRxFg1trWZSK+4V1WCcMWyV1H8
dnN2QyxX8i8k/RVwwZrEiTKpT34kEsioXic42K96YDPVkO5w9eAthVYH7K2FHPfq
s31f0bmnDowkUCxXs0Q9Bnjyf9EotWE68syz6H1ZnK7Nabtb6b4wLRdwP8M4Ufcn
TNfKlvUYBoK5GDoU9tyHV0ZSnB+B5s41N9HIz5QcXTvQZiGsksGmOkrws1R3X7NP
Ny7Q2+v8hLoElFjqz00p+OrZAfXmAtKnML43cHodgznDvy5MQFZ9gynejYUJP+lm
rVNyvauJwrqI8/nfqPh6vUss9NxZ6L5GQu28Ro74iREbzstPZShEOX/SGjoV1yfZ
qyDiBZd9mSptQA1LQNGp
=b71N
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
