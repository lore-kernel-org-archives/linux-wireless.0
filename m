Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223AbXHPNpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:45:25 -0400
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200708152249.09948.linux@baker-net.org.uk>
References: <200708082324.17186.linux@baker-net.org.uk>
	 <1187171443.3960.6.camel@johannes.berg>
	 <200708152249.09948.linux@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WX4nxAoCn66MnZM3m/Ml"
Date: Thu, 16 Aug 2007 15:48:02 +0200
Message-Id: <1187272082.5141.53.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WX4nxAoCn66MnZM3m/Ml
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 22:49 +0100, Adam Baker wrote:

> Aug 15 22:28:20 gromit kernel: [  286.592323] wlan1: Creating new IBSS ne=
twork, BSSID 2a:3f:11:b4:62:c9
> Aug 15 22:28:20 gromit kernel: [  286.593514] HW CONFIG: channel=3D11 fre=
q=3D2462 phymode=3D3
> Aug 15 22:28:20 gromit kernel: [  286.607980] wlan1: Configured IBSS beac=
on template based on scan results
> Aug 15 22:28:40 gromit kernel: [  306.008510] wmaster0: Adding new IBSS s=
tation 00:19:4f:9e:b8:ba (dev=3Dwlan1)
> Aug 15 22:28:40 gromit kernel: [  306.008693] wmaster0: Added STA 00:19:4=
f:9e:b8:ba
> Aug 15 22:28:40 gromit kernel: [  306.008742] wlan1: STA 00:19:4f:9e:b8:b=
a aid 0 enters power save mode
> Aug 15 22:28:42 gromit kernel: [  308.022518] wlan1: STA 00:19:4f:9e:b8:b=
a aid 0 exits power save mode
> Aug 15 22:28:44 gromit kernel: [  309.966798] wlan1: STA 00:19:4f:9e:b8:b=
a aid 0 enters power save mode

So that MAC address, which device is that? Is that some other device or
somehow your own?

johannes

--=-WX4nxAoCn66MnZM3m/Ml
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxFWS/ETPhpq3jKURAqqoAJ0X70DyTV3wNU6WhcMEkuqHBeYjngCeO9b0
CpvXztLpaWh2VpPgfe/7FHQ=
=eISP
-----END PGP SIGNATURE-----

--=-WX4nxAoCn66MnZM3m/Ml--

