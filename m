Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54667 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbaFXTxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:53:09 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so914163wgh.23
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:53:07 -0700 (PDT)
Message-ID: <53A9D720.3050409@gmail.com> (sfid-20140624_220201_509154_8D443ADA)
Date: Tue, 24 Jun 2014 22:53:04 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: iwlwifi-next 2014-06-24
References: <53A9D6CF.9040100@gmail.com>
In-Reply-To: <53A9D6CF.9040100@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="JwTgK5GgXAR425bBvLqJj7PkqRvdFRU0q"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JwTgK5GgXAR425bBvLqJj7PkqRvdFRU0q
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 06/24/2014 10:51 PM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> This is a pull request for 3.17.
>=20
> I have here a whole bunch of various things. Andy contributes better de=
bug prints for dvm specific flows and a module parameter to completely di=
sable power save for dvm. Andrei is sharing the premises of his work on C=
SA - more to come. Eran and Liad keep on working on the new devices. I ha=
ve the regular amount of BT Coex stuff and I continue to work on the firm=
ware error report system adding more debug capabilities. More to come on =
that subject too.
>=20
> I merged iwlwifi-fixes in order to be able to apply patches that relied=
 on patches there.
>=20
> Let me know if you have problems - please pull.
>=20
> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626=
b38f:
>=20
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.gi=
t master

Of course - I meant:

git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

Sorry for that.

>=20
> for you to fetch changes up to c47af22ad630e03053f3eeefd19bd8274989ffbb=
:
>=20
>   iwlwifi: mvm: handle device start failures during restart (2014-06-24=
 21:55:41 +0300)
>=20


--JwTgK5GgXAR425bBvLqJj7PkqRvdFRU0q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTqdcgAAoJEC0Llv5uNjIBXPQP/jUMhYxLuyJ6oYJh2P0WQuk5
NQFYCRrCiUNNoaHGrqXewjdbPgtMhgzIHsXkDGmoQiZXpfE5jsXjPQCTWiObvNxP
f7LuYeWMff7F86Hqd+LKG5TG01vVPTE+sv/EXyzT31+Yaa+2XrpvC3LNnsDBobwB
yGFV4iHz1dm+AdOOkIGjyARuONgurzuTABGrVUO4A50CX6c2juWNNv8OIrPFGvfE
uCaLFRqiBgMxxTnHSc+padN5n6/vgAj8JMV+njO+79JLVuFyZ0LEfdGje49jG8l9
2CYe6qp0e1/K+crljyFBdvAQLsRDNN8ZAYBv7pgUDiXbLjnRr/Ykh5tGMxdUzMmJ
1RbZaK6A/l/THpd9dYSus0AXxWUCGls3PpLk3PJElt97FSgJnwmWqZXtBqfFvHKC
kZcyOOyMmntCDcDDZJTu8VgzFGQZsz+iRBkLU0Ji86E5FbQ2GmCmRjVtP6HsoiIr
4eCmda8LrJWvNFrwCrfFJRGVqesJtdZiUZfBCsYrtK1H0zDq50RzizsEtvRIaOzV
OKJRiKQ5wVowar4nW0Bmt9tZO1HpYvzNVWFZYPsi2n8wVbQqS+8HeteLxb9+sdRT
DjieeeKB4v31mwxlrsYmAVzTLpQNose+m/jpL0BEhWk92IA3XOf6OQMsWzY/IA7+
Q6MAiPNHlub/B+BHBfGk
=48yy
-----END PGP SIGNATURE-----

--JwTgK5GgXAR425bBvLqJj7PkqRvdFRU0q--
