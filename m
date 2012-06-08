Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41279 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2FHQdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 12:33:51 -0400
Date: Fri, 8 Jun 2012 18:33:39 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Andre Heider <a.heider@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
Message-ID: <20120608183339.78a7fcbd@milhouse> (sfid-20120608_183401_687750_77678F92)
In-Reply-To: <1339172904.5748.18.camel@jlt3.sipsolutions.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339137689.5832.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b9uyohfFG46R7QHht6tD3MVUzk4_LJeXp+CC2bRv=NihA@mail.gmail.com>
	<1339167160.4901.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com>
	<1339168452.5748.0.camel@jlt3.sipsolutions.net>
	<1339168600.5748.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
	<4FD21C6B.5000402@lwfinger.net>
	<1339170182.5748.7.camel@jlt3.sipsolutions.net>
	<1339170287.5748.8.camel@jlt3.sipsolutions.net>
	<1339170510.5748.9.camel@jlt3.sipsolutions.net>
	<1339170742.5748.10.camel@jlt3.sipsolutions.net>
	<CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com>
	<1339171159.5748.11.camel@jlt3.sipsolutions.net>
	<CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
	<4FD22727.7000500@lwfinger.net>
	<1339172904.5748.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LEqIwOeHmZvv96Czw0GsBg9"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/LEqIwOeHmZvv96Czw0GsBg9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Jun 2012 18:28:24 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> Right, that would do it. I think we may want to add a
> #define B43_HW_QUEUE_NUM 5
>=20
> and then use it in all the right places instead of changing
> B43_QOS_QUEUE_NUM maybe?

Sounds like a good plan.

> >  and it=20
> > worked for me with both flavors of fw.
>=20
> Well, good to know... I wonder what Andre's bug is then, maybe not
> related to this?

Larry, did you check with PIO?

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/LEqIwOeHmZvv96Czw0GsBg9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0iljAAoJEPUyvh2QjYsOit4P/jvcOo+k4THxYJiloR8UtI5c
9YtsHFECl8oUIn9/XCo1iqKtc4mNNrUpOYkGxdSVzMV++lv9fUXKWnWsv1sT50PV
Or6RDRfVxY2VH8UYvNzKvbKn9JaOE5CGHGYKYbnxWH5mvInFjRlev3zL/p1Zg29h
KZCjBm8lLL1wg0vhZeu0xgJgJR8GwJ/r7TsaZwcsEQObFAjpoNWfBGRF9I+r6gcu
a9WYlo/JvoVBRjvS2haQI2809rINeRTbRwCOWsZgpok1EbCOmqC8QEtaJIxTcji2
zCes+1+QNVzZErH1HTItKmPrEbTAiOgeLjb/YjPJIBUZusz0QCBHCxg7fEOtv6Yr
mguRFSd2iYyqOMJ3lFcC/OUGt1/zX8XGLYRLPj46jtRnQJsdBIgFwDQp5trnlWRy
DGCwgjbZGrG9VibXd+KdA0YaBigQprf0K5oSqkj7TjsNp4v4bJz6/LWAah2HFS+o
13SAzrsW10FhyrXpU/Pl8FYl+od8zCwGcB5f0Cj8Z7FcDBpU6sztVwTyE8ESkILf
UdKC8+r4C79BEIrxkw0HmphczkZ47nm+hWojc2feoEROP2u7ltDsX4SOOkGM4TTO
ks9QIlR3Zaa58V3y7MQIKktAgI4W5kRBlaxAGGurnji0yuO0p/VPEjKstiesRsuX
XXD9CzgKa1Ll2BJURhpu
=KjTX
-----END PGP SIGNATURE-----

--Sig_/LEqIwOeHmZvv96Czw0GsBg9--
