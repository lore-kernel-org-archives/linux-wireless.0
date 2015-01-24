Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59714 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbAXKiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 05:38:55 -0500
Message-ID: <54C37635.6010708@rempel-privat.de> (sfid-20150124_113905_969018_7E8778DA)
Date: Sat, 24 Jan 2015 11:38:45 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: sedat.dilek@gmail.com, Kalle Valo <kvalo@codeaurora.org>
CC: Hong Xu <hong@topbug.net>,
	wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k and ath9k_htc: rename variable "led_blink"
References: <1422094745-12718-1-git-send-email-hong@topbug.net>	<87k30ciiir.fsf@kamboji.qca.qualcomm.com> <CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com>
In-Reply-To: <CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Tf1CdBX7BW7EKeQbdMjjLnepQsL3iCG3J"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Tf1CdBX7BW7EKeQbdMjjLnepQsL3iCG3J
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 24.01.2015 um 11:33 schrieb Sedat Dilek:
> On Sat, Jan 24, 2015 at 11:23 AM, Kalle Valo <kvalo@codeaurora.org> wro=
te:
>> Hong Xu <hong@topbug.net> writes:
>>
>>> ath9k and ath9k_htc use the variable name "led_blink" to indicate
>>> whether the module parameter "blink" is on. This name is easy to
>>> conflict with other variables, thus they are renamed.
>>
>> Please state clearly that this fixes a compiler error found by kbuild.=

>> Also it's very much recommended to add the actual compiler error to th=
e
>> commit log:
>>
>> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple def=
inition of `led_blink'
>> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here=

>>
>=20
> Some more things...
>=20
> If you post a vN (referring to your v3) of a patch, please add a
> history of changes.

What kind of history do you wont to have here? Kernel log should not be
overloaded with patch preparation history.

> 2nd, use the Fixes tag [2] in this case with a reference to the
> culprit commit [1].
>=20
> Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blin=
k")
>=20
> Last but not least, honour credits like Reported-by/Tested-by (plus
> some infos like broken in Linux-next $VERSION).
>=20
> - Sedat -
>=20
> [1] http://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-=
next.git/commit/?id=3D3a939a671225909c19b09bfcb6e4761109e913d9
> [2] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/SubmittingPatches#n159
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Regards,
Oleksij


--Tf1CdBX7BW7EKeQbdMjjLnepQsL3iCG3J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlTDdjUACgkQHwImuRkmbWkAdgD/QMEhPOZkji8WuaA7dfTLAfhH
18olM63ZYqF7feeM6WoA/1hhx2lbw2BgdaFFnjlkgpZGUsyIkh3n95TJZ2bLjWrF
=i+jd
-----END PGP SIGNATURE-----

--Tf1CdBX7BW7EKeQbdMjjLnepQsL3iCG3J--
