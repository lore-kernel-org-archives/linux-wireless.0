Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59393 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaCGJzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 04:55:45 -0500
Message-ID: <5319978F.6060803@rempel-privat.de> (sfid-20140307_105552_195890_7DF2F900)
Date: Fri, 07 Mar 2014 10:55:27 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 00/23] ath9k|ath9k_htc: move dups to common-beacon
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de> <21266.37896.937680.416439@gargle.gargle.HOWL> <5312DD46.3030800@rempel-privat.de> <21266.58035.719712.344551@gargle.gargle.HOWL> <20140306184235.GA7788@tuxdriver.com>
In-Reply-To: <20140306184235.GA7788@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AeO70SW1dJaVvQJ8HkQan966kCGWGxOcx"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AeO70SW1dJaVvQJ8HkQan966kCGWGxOcx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 06.03.2014 19:42, schrieb John W. Linville:
> On Sun, Mar 02, 2014 at 01:20:11PM +0530, Sujith Manoharan wrote:
>> Oleksij Rempel wrote:
>>> I was thinking about it too, but suddenly i don't have enough time an=
d
>>> experience to do it. Beside, there is no need to write usb layer. It =
is
>>> clean and separate from other part of the driver. But the HTC/WMI
>>> interface is not completely separate.
>>
>> Sure. It is just another option to consider.
>>
>>> Now about bigger picture. Right now i work only on ath9k<>ath9k_htc
>>> dups. But there are lots of dup code in ath9k itself. For example
>>> *_phy.c, *_initvals.h. Here are some examples:
>>
>> We already have duplicate detection for initvals. It is part of
>> the initvals tool in qca-swiss-army-knife.
>=20
> So, where does this leave us?  Should this series be merged?  Or not?

Last response was about initvals, my patch set affect only beacon code.
Since i don't plan to rewrite ath9k_htc from scratch, i would assume it
will be better to continue this periodic clean work.

Sujith, are you agree? :) We need your Ack for this patch set.

--=20
Regards,
Oleksij


--AeO70SW1dJaVvQJ8HkQan966kCGWGxOcx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMZl5IACgkQHwImuRkmbWkndwD/RK2Eq9zAqRtv5/8M34S5m6s5
KplQmJqQ/YzhS7LJSxkA/iwdlufz2KKOWkUHxQ6f1hn+tmmLwd/ABWPARRg8sKYx
=RuKH
-----END PGP SIGNATURE-----

--AeO70SW1dJaVvQJ8HkQan966kCGWGxOcx--
