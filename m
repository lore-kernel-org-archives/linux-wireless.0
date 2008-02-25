Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbYBYTa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:30:27 -0500
Subject: Re: [PATCH 11/13 v2] o11s: support for on-demand Hybrid Wireless
	Mesh Protocol
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203967829.6929.16.camel@localhost> (sfid-20080225_192854_280269_CEC357A7)
References: <47be77ee.02098c0a.5eba.ffff81ef@mx.google.com>
	 (sfid-20080222_072128_730595_F951750B)  <1203697819.7082.75.camel@johannes.berg>
	 <1203967829.6929.16.camel@localhost> (sfid-20080225_192854_280269_CEC357A7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1QtB+VkySdduNXxSTdpF"
Date: Mon, 25 Feb 2008 20:30:19 +0100
Message-Id: <1203967819.13162.136.camel@johannes.berg> (sfid-20080225_193030_530687_464B7A27)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1QtB+VkySdduNXxSTdpF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 11:30 -0800, Luis Carlos Cobo wrote:
> On Fri, 2008-02-22 at 17:30 +0100, Johannes Berg wrote:
> > For each device as in the peer or in the hardware we run on? Would this
> > need a new entry in struct ieee80211_hw?
>=20
> As in the hardware. To have the entry in ieee80211_hw and require the
> drivers to fill the value would be the best,=20

Ok.

> the problem would be to
> actually find out meaningful values for the hardware.

What sort of value is this?

johannes

--=-1QtB+VkySdduNXxSTdpF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8MXSqVg1VMiehFYAQKIPg/9GY2V6eU8YO742JRtI0PRPB2Qe5NQGPLk
iFgrpX2vk38+Ab+b4GOPGQPzPGDWyD+xijoC195hOu3XpWUchHlDyxq7eAjes7YC
8bn0APJXuQCUsVLXxOiUndF4ZpwCGvjodTz7afV3UdlT/58RqsBi3O+FMyGxPfPo
I51s3os2B4+dzto277d7Ttqo4O5BKBEmfi3Hs6ZQRDf1ZWqVjaxZp9Q98YXKHdN+
3YDtmjseQ459hAAdzG9BtCz8eGQ/jTTYd15vs3xh+MunHweSKuu37faTbHkOosQ0
bbdzQP6d20EmGvRl54dQViXS3/M9ffU6x3F2XFW/oQ3Izc3JpSFbxR1oiEGYiH2k
kCML6SL8x7i+t9igk/ZdTcQZC3hZcHBldGTHNMyc6ydMfdsR3kChfcdtfhpp/CO7
GJPMUZf9seklvvdqoRXkhJyyVV/NJdqb9qK3GNVZQSCRqzDE1K67zEIc4XGrPQPe
Qp+a8uTKozehyXPMoMy0wcpeDYrbRWg77hZIqRIdJn5vWRUt0sZtpKB24IYIKWac
p9St5iG7hOv1pkp7dnFeZxxp+EUipbwrdjhRrpMKq/OK7ElR4wdko5W6od/jT2pJ
351ZvsG6tHTR9KKPUM+V0y4bQhh6mZyBNpB6PKqdvDZonBEkN2B8vDQOMPLdxm+3
NM8tbSNePk0=
=xOj1
-----END PGP SIGNATURE-----

--=-1QtB+VkySdduNXxSTdpF--

