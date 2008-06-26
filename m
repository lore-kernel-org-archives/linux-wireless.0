Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYFZSJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:09:56 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	cs010101@gmail.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1214503403.18039.6.camel@dv>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <200806261821.31643.mb@bu3sch.de> <1214498071.30722.22.camel@dv>
	 <200806261846.17962.mb@bu3sch.de>  <1214501000.3783.0.camel@johannes.berg>
	 <1214503403.18039.6.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-A+snWrR3dk8gOq1UEjlV"
Date: Thu, 26 Jun 2008 20:08:59 +0200
Message-Id: <1214503739.3783.14.camel@johannes.berg> (sfid-20080626_200958_979253_FE61A685)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-A+snWrR3dk8gOq1UEjlV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-26 at 14:03 -0400, Pavel Roskin wrote:
> On Thu, 2008-06-26 at 19:23 +0200, Johannes Berg wrote:
> > > > What's the current TODO list for the AP mode?
> > >=20
> > > I think there are some issues with the rates.
> > > Maybe more. I don't really know.
> >=20
> > It's on the todo list on wireless.kernel.org
>=20
> I see it now:
> http://wireless.kernel.org/en/developers/todo-list#APsupport
>=20
> It would be great to split the list into categories.  I don't think
> "data frames on cooked monitor" make the AP mode non-compliant.

That's true.

> I also suspect that certain fixed are needed only for 802.11g or 802.11b
> compliance, but not for the original 802.11 compliance.
>=20
> Say, if we limit the rate to 1 Mbps, are there any issues that really
> make us non-compliant?

The fact that we cannot limit the rate like that that?

johannes

--=-A+snWrR3dk8gOq1UEjlV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIY9s3AAoJEKVg1VMiehFYy10P/0Juk1LjUbGBDl7FJE3l672E
afcFQ8JIOVKzw13V7xkFuSFoCM60PmpMNIwceAi3sqOx8rXJswRHXInEqL7Va/c3
95CP4QAC7jL9RD3IYkhFltN3qbh2YIYuIYpbvdrk0hnIACvA9MFTfDbpxgxaXLIn
jAjn06nSWVZ594OS3ED497RiM64eEc5gLvbL9F+dOH43i6gjW6TafpZ5VONT+0T2
8zE8cR9XEOKWndYphd7yHPn3qO/azwklSKiOP+tLXXowu3tmLlE8MoA41wmdwSUx
j+MMNXza/LCxQE2o2mYA3a7yrYt/xt7U15Tr/kq5XOubMuqCPSSttbWHIMNjaoPm
2Y7mOuCSF0SxK09J1ochndQiL2XoLUAKSU6rtIUlLv4Q/HGFVlptL5tD5NitHCeY
nWWquKol60dSKJTDhRUc8ruzRm9Fdz/CUTVueH5wCecx903R+7sTyIR8M4Y+i9cB
lfgKBpZSCbzjoUfcFC9xlHRP40MbM9E0HUbGO6tXr78X/PoIOelQzpaLQpQx6w3D
nynJxTZdr2I0xF3MOSAfIbL444LHf0HCftbMeebS+q7W1svP/+BxvE6Iv+S/CHy8
aU9SdKRrHwta7J7pXRA91chYscPhpbRoeIElxs4e0d6CrayS4v0BSG6ZCwWTrdUI
5RWd/C6EOaDsveaJJC3o
=YJUL
-----END PGP SIGNATURE-----

--=-A+snWrR3dk8gOq1UEjlV--

