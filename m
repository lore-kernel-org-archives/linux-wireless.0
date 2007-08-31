Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbXHaWB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 18:01:57 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <20070831205524.GA11128@tuxdriver.com>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070831205524.GA11128@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aCRp1sl8eWoiCQmR0TWt"
Date: Sat, 01 Sep 2007 00:03:05 +0200
Message-Id: <1188597785.7585.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aCRp1sl8eWoiCQmR0TWt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-31 at 16:55 -0400, John W. Linville wrote:

> Otherwise, it mostly seems acceptable.  I think the mac80211 guys
> have a few issues -- hopefully they will chime-in here now?

Few things off the top of my head:
 * mac80211 will be very noisy with the recent key changes -- the
   iwlwifi drivers don't allow disabling keys which is sort of required.

 * oopses when you enabled a monitor mode interface and have iwlwifi
   debug enabled

 * doesn't honour mac address setting, always uses eeprom mac address

johannes

--=-aCRp1sl8eWoiCQmR0TWt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2JAZ/ETPhpq3jKURAoK5AJ0VBo2C/TMBlu+GeU0UNd3Fkuxx/gCcCVMV
dpIHCpmGQ4YwVwcm298gHpk=
=6exp
-----END PGP SIGNATURE-----

--=-aCRp1sl8eWoiCQmR0TWt--

