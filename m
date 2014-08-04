Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:35384 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaHDNeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 09:34:05 -0400
Message-ID: <53DF8A36.1040402@open-mesh.com> (sfid-20140804_153409_458285_E2401BCA)
Date: Mon, 04 Aug 2014 15:27:18 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: fix aggregation session lockup
References: <1406122854-60239-1-git-send-email-nbd@openwrt.org> <53D6B87D.6080007@candelatech.com> <53D6BC7F.2020002@openwrt.org> <53D7C661.2040107@candelatech.com>
In-Reply-To: <53D7C661.2040107@candelatech.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OSLrre4br0bBulurovhNVrT3thJB4aUwj"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OSLrre4br0bBulurovhNVrT3thJB4aUwj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable



On 29/07/14 18:05, Ben Greear wrote:
> On 07/28/2014 02:11 PM, Felix Fietkau wrote:
>> Interesting. Maybe you should ask Antonio for an updated version of th=
e
>> patch that he used to debug this issue. If you give me the output of i=
t
>> while it's locked up, I might be able to figure out what's going on in=

>> your setup.
>=20
> What is the easiest upstream tree for you to debug?

Sorry for the late reply but I was pretty "disconnected" in the last days=
=2E

Is the debugging patch still required? If so, I can dig in my buildroot
and retrieve it.

Cheers,



--=20
Antonio Quartulli


--OSLrre4br0bBulurovhNVrT3thJB4aUwj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJT34o/AAoJEJgn97Bh2u9e3ZsP/iFmMbZDdjVP/jiTUcRU31CQ
nEeynOPsI+O6zHF44jmgnT5YwYch09Nyp7NK+9U0NjJQckVsoej+2kA//XWY36So
1ZjJLu5oRl00Fhms8FR0lOoU4FIZyZRPnqFpyk+z9DhQziKxk1OIt+NWFyyhQF/P
tAgoEEwmW3E2gR6+qPsYY26iXiisEcl/i2OpF8ANomB0hCsO0OugC3yJ8sKtJzP5
dp0Qsj3gq+ZdRANAsOXXXwJ065iok96Oe3frwEH5YJ5LLLnFjFhbyLI34eCPOPG7
nYk5IMDYlfinx6e1r4B81i0LP0paOGzmdFAv0tkkAmRF6ry4VhWSisdbXyPtACOJ
bZQvT7mC7BTqVW0ShFGBiKrxZw7Vab4HtFNG8qxPSaKfTb/9+whiV6/8CIQNTtBB
VGeW1NUQHN6aU0YWgn3kmFG10OtlxUbhPPQRsdLudlBb+imuckvafieo6l3Km8E6
YGJdhAS7Ps3LZXaubqj5DuB59y7CS4M+fUiqPj5CN8UgJGpHjDX/CSXopTaF36Pc
JiYLJuw+56sFkttPLcBCGlbi+JgUQa+AceaLV5uxz7NsLBYbLblrqARYFl0Hb8YY
XbaDRlG3AcbsKXxqlveLoHCFBYDnBq/2zYKNjJtjg8/jjgqSEml/laoJr6of1aTK
18oYu6zXi0xhpSzcPcg1
=7480
-----END PGP SIGNATURE-----

--OSLrre4br0bBulurovhNVrT3thJB4aUwj--
