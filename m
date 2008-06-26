Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:58760 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbYFZDPs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 23:15:48 -0400
Date: Thu, 26 Jun 2008 13:15:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: pending wireless/wireless-current merge conflict
Message-Id: <20080626131536.9b26269a.sfr@canb.auug.org.au> (sfid-20080626_051552_280835_D3743D28)
In-Reply-To: <20080625180430.GA13730@tuxdriver.com>
References: <20080613215601.GA8345@tuxdriver.com>
	<20080625180430.GA13730@tuxdriver.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Jun_2008_13_15_36_+1000_fL_f_JmstJN0XN68"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Thu__26_Jun_2008_13_15_36_+1000_fL_f_JmstJN0XN68
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Wed, 25 Jun 2008 14:04:30 -0400 "John W. Linville" <linville@tuxdriver.c=
om> wrote:
>
> I just sent a pull request for Dave that will result in nasty-looking
> conflict in iwl4965-base.c.  I have a sample merge available here:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6=
 merge-test
>=20
> The overview of the resolution is to ignore any changes in
> iwl4965-base.c and take drivers/net/wireless/iwlwifi/iwl-scan.c from
> the URL above.
>=20
> Just a heads-up... :-)

Thanks, I will check it out.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Jun_2008_13_15_36_+1000_fL_f_JmstJN0XN68
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhjCdgACgkQTgG2atn1QN/XXQCfZEY93sdHTKdyF6xerc+cfNqz
f/wAnRLHi3M8G4t/YmAQaJUebt9Itc5Z
=Eq3k
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Jun_2008_13_15_36_+1000_fL_f_JmstJN0XN68--
