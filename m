Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:35023 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab3LIUdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 15:33:05 -0500
Received: by mail-ee0-f43.google.com with SMTP id c13so1791999eek.16
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 12:33:03 -0800 (PST)
Message-ID: <52A628F7.7050408@gmail.com> (sfid-20131209_213309_392649_033EE439)
Date: Mon, 09 Dec 2013 22:32:55 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2013-12-2
References: <529CF2D6.1080008@gmail.com> <529E129B.6080807@gmail.com>
In-Reply-To: <529E129B.6080807@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="kP6NiTSSG8Hl5nf7pLHF5fSvHETtxvNKg"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kP6NiTSSG8Hl5nf7pLHF5fSvHETtxvNKg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

On 12/03/2013 07:19 PM, Emmanuel Grumbach wrote:
>=20
>=20
> On 12/02/2013 10:51 PM, Emmanuel Grumbach wrote:
>> Hi John,
>>
>> This is the fixed and enlarged pull request for 3.14. It includes the
>> patches in my previous pull request that was based on a bad patch.
>>
>> I have here a big rework of the rate control by Eyal. This is obviousl=
y
>> the biggest part of this batch.
>> I also have enhancement of protection flags by Avri and a few bits for=

>> WoWLAN by Eliad and Luca. Johannes cleans up the debugfs plus a few
>> fixes. I provided a few things for Bluetooth coexistence.
>> Besides this we have an implementation for low priority scan.
>>
>> Note that I had to merge iwlwifi-fixes into -next to solve conflicts
>> before they hit linux-next.
>> Please let me know about issues you may face - Thanks!
>>
>=20
> So - I found out that merging iwlwifi-fixes wasn't a good idea... So I
> updated my tree and added a trivial compilation fix.
>=20
> New head: 2f579448f3a60c8ede544dd0951b8d2a2e282ba2.
>=20
> I hope that I have done all the possible mistakes now and that next tim=
e
> I will get it right the first time... Sorry for all the mess...
>=20

Since you merged wireless into wireless-next, I decided to rebase my
tree on top of wireless-next to make your life easier. I solved the
conflicts you would have faced.
New head: 9d10849e4ea8bf9d8da80afa73918a9fe45c09ef.


--kP6NiTSSG8Hl5nf7pLHF5fSvHETtxvNKg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSpij7AAoJEC0Llv5uNjIBYVIP/jCy/Tv9jnMrJ5KV6wVYTW/f
ztocx5Iw5WzF9VKNaYRK5yF/8/sdrv9cVBq7hkH8uJN3h4k9WdO52IZXixWXfoCR
aEf08agA1/cvs/VepIQ4M7dsd7J3/5u4jSIPjZzVGfuAaiuLg31W61tYh1SfCvf0
3qxWy3Bq5O3dN48PmB7nPGuovwpp52+Zpz7PC9hYxmEdCPgcuXK8lNruEn8Q6QGb
R6nYsiIXOxeiWz33nznZALbZLwS2dQk/yFe7Nbhg9m6Z/jQODz+kME3CTickW1gP
MIhrPMVl0xrERGk5DKdH6HchwCCIzju15R8I1t1WKPpo4MuMjQFbwpdHDxadQFR4
bUYJOw4yXpxCe+Ue5Bz+h4HGQfOzlIUDiTQyvsqh6g0x7a9cYoiQVKxLfyaNUoaT
uLrGgZTPbH6d2q6HFp+r6+8alh/EwikQXjis7z+P25S1vtashG5NFWi1aXZzh9QD
iLeiJbnPCinb3u7nSvSwrSguTtQINBwzhyA8F/WXOrgmpUIkTyjs5TOFT3OD8bBk
d7WzRxeHrCh+WmfV0BPRybfCkkWKTLKKI1rLYhEFLNXFhRa05N+1j8ZDfRtGkARb
m7AjeJydVueuLwrj8XZ0K+SNjkkKMhNtHJz4HcqvYa09PLJE4pwSnkNTS7XSl9fp
uHa97icpbEqRKlGWMV8t
=fSHv
-----END PGP SIGNATURE-----

--kP6NiTSSG8Hl5nf7pLHF5fSvHETtxvNKg--
