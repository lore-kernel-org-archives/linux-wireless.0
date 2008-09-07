Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYIGOkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 10:40:40 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com> (sfid-20080907_162439_026106_5D1A0CC9)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 (sfid-20080907_162439_026106_5D1A0CC9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zWHsp/rR18+HePXdi/yA"
Date: Sun, 07 Sep 2008 16:40:32 +0200
Message-Id: <1220798432.31304.13.camel@johannes.berg> (sfid-20080907_164107_794936_C96C7B59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zWHsp/rR18+HePXdi/yA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 17:24 +0300, Tomas Winkler wrote:
> On Sun, Sep 7, 2008 at 4:39 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Sun, 2008-09-07 at 01:14 +0300, Tomas Winkler wrote:
> >> This series should fix mac problems in disassociation
> >> There are two basic problems disassociation in current implementation.
> >> The order of steps in the dissociation flow and missing proper
> >> disassociation when moving from one AP to another.
> >
> > Mind if I adopt this patch series? I've done only slight modifications
> > so far (the int->bool thing I asked for) and have rebased all the
> > patches I had already posted on top of it. The arguments to
> > ieee80211_set_disassoc are changing a lot in my patch series anyway so
> > I'll just work on top of the bool/bool thing and  then fix it up, ok?
>=20
> Don't mind just need to test them properly and update commit messages.
> Any suggestion how we do that?

I've already changed the commit messages slightly, you can find my
versions at http://johannes.sipsolutions.net/patches/kernel/all/LATEST/
(disassoc-part-{1,2,3}.patch). If you want to test those by themselves
that would probably be useful, and if you want to test my complete mlme
rewrite I'd appreciate that too, but I'm not done rebasing yet :)

johannes

--=-zWHsp/rR18+HePXdi/yA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIw+fcAAoJEKVg1VMiehFYb2kQAMD+7J7WUGXP86Sf2cpyE8LA
jKZW1eE2d89Gpi3YywlNIgQeQgFQc/UgNzO979nQ0AzoQKzMuZcdzk1mXMjZIe0V
up72ZZMuxwAZeFbFIw81HyijGIHVsrac+/70cU+wzDwuk+1f7QRaN92YeMKkmyrK
orLCpFVRaXAAnYE/P3egsVbygNcq6oyDfjR/tL4OFqLdY6q7GVH9aiW5k4XpZLeH
NtRUuGJPJ69Fy2ja+N/c3WWzDPZ9C+7miwfK7ik1Ef4lYKYezz9Z2LYN5a+9R1C2
0N9O8Q7DLMjfqtk3FXjf6MsfgTaY9nhKR0wlqMLHl+QuC3kJr1wTjhIbJaB+WFUE
/ypgTPwgXR8yLu9N0cAQOONqTSil70g/HDiKfwkFyhFFgtQAkTPURKotnbRoOWNF
rgTx6LNxK9sbMWdC5EheCC0WgyBZtYFJQOmMAT2yyqR8qUDJtd5m/QxTTEY3SYKL
cnhtFOFvoZw43+9IRKVMumfvSWT62ryvswG/K1vmIvsekboXNdnCCpdtVudFakxT
S26iHp1ajmy/9O7ncRBvplsta+K8oCLKzB3NnUFeABwqgmLjMwgAGHyzv7+DZw+5
TvbUshLvRjYqtJ3R71UPKP7cmU8u3lPKNQNbv0Ukr3a8UqreyieQUJgS+9BiCgw+
UYdzz7MupvK7Th8P24qq
=Vesm
-----END PGP SIGNATURE-----

--=-zWHsp/rR18+HePXdi/yA--

