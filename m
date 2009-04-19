Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZDSSeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 14:34:09 -0400
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419181820.158810@gmx.net> (sfid-20090419_201854_422451_34B7093F)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240147370.898.0.camel@johannes.local>
	 <20090419143337.158810@gmx.net>  <20090419163204.158820@gmx.net>
	 (sfid-20090419_183237_340935_6640098A) <1240160041.28138.0.camel@johannes.local>
	 <20090419171546.158830@gmx.net>
	 (sfid-20090419_191552_279073_CA045D96) <1240161550.28138.6.camel@johannes.local>
	 <20090419174538.140620@gmx.net>
	 (sfid-20090419_194610_734041_B2E7FCEC) <1240164047.28138.9.camel@johannes.local>
	 <20090419181820.158810@gmx.net> (sfid-20090419_201854_422451_34B7093F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NEPuq+BNHMImbP26VURP"
Date: Sun, 19 Apr 2009 20:34:06 +0200
Message-Id: <1240166046.28138.11.camel@johannes.local> (sfid-20090419_203413_964838_EA810A43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NEPuq+BNHMImbP26VURP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 20:18 +0200, Alina Friedrichsen wrote:
> > No, that's not true, you could well want to create your network on a
> > channel that isn't used that much or whatever.
>=20
> Okay that's is an argument. But then I would implement it more closer
> to the the handling of the assoc() call.
>=20
>  * @channel: The channel to use or %NULL if not specified
>  * (auto-select based on scan results)
>  * @channel_auto: Auto-select channel based on scan results,
>  * only use the specified channel for creating a new IBSS.

Actually, I'm arguing in another email that the channel_auto should be
removed in assoc... And IMHO fixed is much clearer for what we (well you
mostly actually!) want.

johannes

--=-NEPuq+BNHMImbP26VURP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ626bAAoJEKVg1VMiehFYz2wP/2E8dNsO6zK5h+ErtjJHcr0I
4L+Xu51iAkL8eIN+s+3cj01IysUhmAuV3UVgfzq1b/dELbozNh6OMNTlpxXRGPH6
Dm1YzsANKzgU0QQtiLFh98rYYd0xOOamYS4CfkxBOPOERxKcyBPidxmOYPu3+a6I
Ij6Jymno1DQz53Tlvyi+k5zqmrfEHfGSDeXeuolkRjv+ZmNknKhPqDHX0d38Asx0
UIERJIfLMeDEkDpKtIe4Z8gQQIPLKHlps/K7yJJK1RIuQNS3cEWIiqyTYkQRnGGn
9oMUMrEFDCOSbw7fTo9wjaInPtZZFQdlQQzPDDpyw+tcu5dRG5HHDc5GEDMmhwpC
1UfDk7E8WLIaZKSEruC7hDfQDPEA7jV3uPZ4VjxNHYefaAXUqLUiW2OUAuWNcP23
govGCy2Uny29nAccOPktbk/mgD+MTAU2J1Pp8Kq5bKOgYK6EQZt5PGpChjKk0oSN
JXbtrcaHs8pHaBThjgpJ0+8UBLojBVEjxE/B2wbS5c51ioSy/zD6lYFvhlDxvuEL
uvFO9pkGECePBqrBImR06pn09CGRCT1IuKFd6U+IkG37rTJB3lAtMlBPlEci/Acl
3aJnpVH6J+Hq7aje6wr9bYUbMNptj3WWR5JE4BINqWrwSavdk2HJVqeEZi3Pt/Id
RwCbQfXBt9+tiQ5NTrzD
=A02T
-----END PGP SIGNATURE-----

--=-NEPuq+BNHMImbP26VURP--

