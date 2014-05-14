Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:56420 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaENVQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 17:16:06 -0400
Message-ID: <5373DCC7.9070708@open-mesh.com> (sfid-20140514_231610_271905_B8D26956)
Date: Wed, 14 May 2014 23:14:47 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Subject: Re: [PATCH 3/7] mac80211: add new RC API to retrieve expected throughput
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>	 <1397484205-20905-3-git-send-email-antonio@meshcoding.com> <1398440716.4152.27.camel@jlt4.sipsolutions.net>
In-Reply-To: <1398440716.4152.27.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a34WJAWs3KVtFjMOFwIWUd0nAvmqTHGtJ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a34WJAWs3KVtFjMOFwIWUd0nAvmqTHGtJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 25/04/14 17:45, Johannes Berg wrote:
> On Mon, 2014-04-14 at 16:03 +0200, Antonio Quartulli wrote:
>> From: Antonio Quartulli <antonio@open-mesh.com>
>>
>> In order to make mac80211 export the expected throughput,
>> a new API which extracts such information from any mac80211
>> SW RC algorithm is needed.
>> Therefore add the new get_expected_throughput() member
>> to the rate_control_ops structure.
>>
>> The exported value is expressed in Mbps/100. Such unit has
>> been chosen because it is the highest precision that
>> MinstrelHT can return.
>=20
> Same as in patch 2 - and realistically 2/3/4 could just be squashed.
>=20

Yeah, I will specify the 0 value as "I don't know what to provide" and I
think it is fine to have just one patch.

--=20
Antonio Quartulli


--a34WJAWs3KVtFjMOFwIWUd0nAvmqTHGtJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTc9zRAAoJEEKTMo6mOh1VnfEP/R9WGHaPpFYW5QNjxxORMXc3
bjI9zs6MQTFiRr1IplNjuMZ26U+6zSIotK9PskGySus3iBBFvBHTp5wu7jIh2ykf
WjLi+pdZOtJ6RPsDMshW8fPNSuzHjV93UOOdWzvE0KtUPqmsHL/DSWbqPbRSgH2i
BlBI+gshfwkc03JESurBYN4ok3xGqzSSHiI1EKQtHt2oq9fUDg2wxoSEQcI24lbP
4YJs7sGDkyeF91QhwTxnMmViKHQaYl3GViyETW2qpacAbhStwwn66hC1MzThPyxi
8JbjZN89rtgljvYMt8Y6bMtzW2tYDjFqa0Q+gspMu8eauA4c4b9xyVh0uApG3Klu
FFFXC0fFDVE/0z1E7HV1bUKCh7mKk5Qyf/+pJXp/bluJcxxGFC6I/YqzGfNdbYfA
tDr5XBnIWMPs/86qT0kzHUSztwfr7+8UtevQJK1TxgijC6j0L3qVJHI4C+6A798j
fj9xb1PcGrzrZrYCCSlLCKQ8d7K3QEwX75l6LofH/JuWogZPXbyECSUp4UnD8fxi
wxeFZGz58wH9mbutZDZ5yNw5+mrVBEmRihWHTouqDQ4L4CpwP+sCOuv93D9JDpvb
CNo9ZN1glUizV95DoEvJkt3JwCta6qJtlDE9tyDqF4T8ONunXT6ecRLnUZU8OAU5
xFhaTeNOZbxU6mjWk+8S
=yoLI
-----END PGP SIGNATURE-----

--a34WJAWs3KVtFjMOFwIWUd0nAvmqTHGtJ--
