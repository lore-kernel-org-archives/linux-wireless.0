Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYFXLEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 07:04:00 -0400
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com> (sfid-20080624_125428_921964_DD4C29AD)
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-5-git-send-email-tomas.winkler@intel.com>
	 <200806241242.11727.mb@bu3sch.de>
	 <1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com>
	 (sfid-20080624_125428_921964_DD4C29AD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wSAk6AqYz3WmvSNslF+2"
Date: Tue, 24 Jun 2008 13:03:16 +0200
Message-Id: <1214305396.8967.283.camel@johannes.berg> (sfid-20080624_130404_152077_39C6C7F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wSAk6AqYz3WmvSNslF+2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Still many people are using wireless extension and this is probably
> most convenient way to get this info.
> For example 4956 comes with 3 combinations g, ag, and agn.
> It's displayed upon iwconfig

Heh ok. I would just say "print out the rates" but I guess that doesn't
work with HT yet.

> >> +             strcat(name, "g");
> >> +             is_ht |=3D sband->ht_info.ht_supported;
> >
> > What about b-only devices?
>=20
> See the log message...(known issue). Currently you have to loop over
> rates to get this info. I wasn't sure if they are any b-only NICs
> under mac80211 so I didn't run to implement it.

There is, adm8211.

johannes

--=-wSAk6AqYz3WmvSNslF+2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYNRwAAoJEKVg1VMiehFYzj8QAKPRQqi+WNDUldUlLknic0/8
jh1fGZwpNjbTrqM6QpmJfBAZvwi3Ap+lv1qXvZPGp/cM5Hxc76V7F1Z/L92p7e91
9bh6Fzzmu9nGR0tmy+jxBB9an4X23kYFJHaPBr/MFddiCsV8CPIkMuhid9bq/28a
77zgLlfQK5oLmWmW3432mKgeCb0tepbBqKycoV4LLpYy4GgFNR1edtcq8UMy51wo
RX+EeDruYjOJUzrcTOZz8YzPWdycDAGLBgvZYikfxDaDi5BpA9hNutAAE6qS2p/9
B4RTR/h4AYELsp8KqPlBCuVyzunRHOje2YhuARhJ/v8Mm4K9BrOfSPxp3lGw1PWn
lpowXE8V61llBhesh5l9arAVqKbqcfKFR3PLj0571RsSfA2+NJVMZIDAEm4z+zEg
68r4oKhZ02ezLH0wK0lHhQyo3roui2kKvUpT7dafLSJ4WlKk35WDo8lVDvjKnzZl
8K7NwzkO3aQcjnyMJzMGfam9Mg2sgIHF6lTh1HInwujumP21hOZEgpyTXta8WZze
MD1o1Au4PMaqC27lU38Ab1p7g/x/hjW65WtR69Fm29dLGSlH3MgoWG8udjpE+ZK5
Yji+c/URDgLQEd9yUJCNzgrkZXumXDSJFa2Biy3SgLnW1iC9wuR05AtAyjYBwXxe
HDmpx8b1g+kaSaoCkdXu
=OndC
-----END PGP SIGNATURE-----

--=-wSAk6AqYz3WmvSNslF+2--

