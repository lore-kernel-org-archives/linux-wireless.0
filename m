Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762956AbYAKXEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 18:04:36 -0500
Subject: Re: handing cloned frames to netif_rx()?
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080111230105.GA32656@gondor.apana.org.au>
References: <E1JDSPG-0008Of-00@gondolin.me.apana.org.au>
	 <1200092285.3528.5.camel@johannes.berg>
	 <20080111230105.GA32656@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I+N28rWhA5od6jajIGrF"
Date: Sat, 12 Jan 2008 00:04:17 +0100
Message-Id: <1200092657.3528.7.camel@johannes.berg> (sfid-20080111_230503_120734_726C42D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I+N28rWhA5od6jajIGrF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-01-12 at 10:01 +1100, Herbert Xu wrote:
> On Fri, Jan 11, 2008 at 11:58:05PM +0100, Johannes Berg wrote:
> >
> > Ok. Yes, we will of course adhere to that, but I was wondering whether
> > maybe the net stack assumes somewhere that a packet it got from the
> > driver can be written to w/o copying.
>=20
> All parts of the rx stack support clone handling because they can always
> run after another handler (e.g., AF_PACKET) which may have cloned the
> packet.

Great, thanks for confirming, we'll do that then.

johannes

--=-I+N28rWhA5od6jajIGrF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4f18KVg1VMiehFYAQIrTg/7BPUVTEbN4vPoi4zNHuuZLgyRWx/vsn3I
1A1lsXs37rtmxtD2QLZ8oXR+B+rlJZ4yJolBLKT5hRCNVBrRANKCcgVUgf1PnkVB
YuucoYR5ZHZhEUpmdHVDWgUsm3bNo6RXsw1mv6WhAN4G16hSexp6unfl5kNKT6V8
7Gk+a50Pa2uBXLrJ8W2uoftMjpb3giouLFSVwC9bEuoOjrNdnCd++eTUWv+9WUy8
BWXaWdFLlnFI6qNfLzOTmkmJd3+zK8jrNMUIK3yiTBAz2k/vAn8JXqJiUHOuJDUL
X1p4xscmsj29sSN/oT1koEHiw1pfXPHz5GoUDLiSsUgak1k/dLliPVgVSG8Reh2m
ltHsyLQkwI5dQ1cJ1/S0y0IADH1bzW+eQYdvo8ljvrXoHnfHhbW1oTw4sQ22VlI6
jpiN9hFRIgIreeB6BXnE0kwmeVJITv4/uE6GRvwV++KRB6qgfTS62zCsEcL5LeQV
OUMEwWjHeGYJZdNXL1rZnjjeyACCZwp1rS0oHz3DfIk5uLrZAWHq4QvA4iKPIfoJ
jWMti1urdYdQMsaprhmZbhWL0frQD8ABzTRlqw1CjaeQUNTTGR9jKKPw5qDIqqB0
/g1XltVm2f+VYFB3go3IXhL+9kvqQmppV6o5zOABxo7DmL60mNWjykcL1u7XFN9+
5DmFJvQe7Xs=
=XK/5
-----END PGP SIGNATURE-----

--=-I+N28rWhA5od6jajIGrF--

