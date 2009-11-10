Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbZKJTgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 14:36:37 -0500
Subject: Re: [PATCH v2 2/2] mac80211: implement support for 4-address
 frames for AP and client mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4AF9BA8D.6010201@openwrt.org>
References: <4AF9A886.9090902@openwrt.org> <4AF9A8E1.6010104@openwrt.org>
	 <4AF9BA8D.6010201@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6q4W0I66BB6+ydhjktee"
Date: Tue, 10 Nov 2009 20:36:12 +0100
Message-ID: <1257881772.7037.65.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6q4W0I66BB6+ydhjktee
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-10 at 20:10 +0100, Felix Fietkau wrote:
> In some situations it might be useful to run a network with an
> Access Point and multiple clients, but with each client bridged
> to a network behind it. For this to work, both the client and the
> AP need to transmit 4-address frames, containing both source and
> destination MAC addresses.
> With this patch, you can configure a client to communicate using
> only 4-address frames for data traffic.
> On the AP side you can enable 4-address frames for individual
> clients by isolating them in separate AP VLANs which are configured
> in 4-address mode.
> Such an AP VLAN will be limited to one client only, and this client
> will be used as the destination for all traffic on its interface,
> regardless of the destination MAC address in the packet headers.
> The advantage of this mode compared to regular WDS mode is that it's
> easier to configure and does not require a static list of peer MAC
> addresses on any side.

Looks good, thanks.

johannes

--=-6q4W0I66BB6+ydhjktee
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+cCpAAoJEODzc/N7+QmaddoP/0WJQKURM6pm+tK/C60Mb54f
lhfZKcuJf+MTvO7+MUP88Jsd/sjs02l+2gTU26tnOlVtQ0ulse8G+zEukDZirvPo
Vgfryfulp4UtL8XcctU/zC4UNdUfVcFLQQ6qi+PciPO3/V+UulHCle/yJ9tqEPT1
ULgQeAABHcVzOzZ1pSqr56Pr2GmtgaHW2VIbMvh9xOG6X0jZXinQv6q9uYXdV1QG
hLNaV18KEI7uKvXRGLBMrfwu+0drVwwrvCBJdmS6n/ZDHQggIKY1rZ7soK4mGYjz
cYJXidrx2altabVJwMlEDPACcG9oMQWO1jl9F2bhKYlSGTML1a/0KhCQUlVyMr7b
9tvXqJeQzzOM3AQLH8/wFaNdn0Jfc8kQZEPKOxfomf/S/K2JSjnntZBnXSnkdyM1
oC3j3djvZs8/YQ0yoe1zATYeGBcFGhQK0BifrLEO516wphap7+llB+z69ShrMr9x
t+/uiC7oMC2s3HFhocflUutGbUk0tHawY+1hz6yNE7GMNbMfxOTgBTUFmp4/zv6J
H+gB6+G5shGnkOSHqxdlnRPjpsXmtXhGtor4o8MBtnqHpUoAIZ4Z9iVnEwiRwO3t
t2WmnUWQvTsRCsKlTZRAhjqgwEuI/jdbY/CLKx/ygKcBwptM7kQ/IcsvQ+4jmwve
sJBIASS9NG4be17V4HU9
=e3FI
-----END PGP SIGNATURE-----

--=-6q4W0I66BB6+ydhjktee--

