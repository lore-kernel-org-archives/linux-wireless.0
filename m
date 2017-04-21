Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:57230 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034387AbdDUL3S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 07:29:18 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org
Cc: Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@gmail.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
Date: Fri, 21 Apr 2017 13:29:14 +0200
Message-ID: <1811221.G4Vz0DPyQ8@prime> (sfid-20170421_132923_826311_DB13AD1E)
In-Reply-To: <d4acedac-e28c-4c1c-d112-40557d52f3a2@candelatech.com>
References: <20170323133048.30062-2-sw@simonwunderlich.de> <CALLGbRK2d1wZpfLnXu_UDWxVPA9LvejFyEFpzMub56uLH0+DTw@mail.gmail.com> <d4acedac-e28c-4c1c-d112-40557d52f3a2@candelatech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3889230.LO2l9a0JLG"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3889230.LO2l9a0JLG
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi,

On Tuesday, April 18, 2017 10:09:59 AM CEST Ben Greear wrote:
> [...]
> >     In my personal view, we have quite a few obstacles which I consider
> >     "enough", but would be interesting to hear others opinions ...
> >=20
> > I'll throw in my 2-cents. This patch is treading on very dangerous grou=
nd.
> > I can't speak to other regulatory environments, but at least the FCC is
> > cracking down on even the possibility that anyone can operate a WiFi
> > device outside the regulatory bounds.
> These patches make it slightly easier to use the licensed bands, but no o=
ne
> can accidentally use them due to the regdb and other constaints in these
> patches.
>=20
> So, I don't think these patches offer any fundamental new vulnerability
> that should concern the FCC.
>=20
> After all, someone who really wants to do evil can find and apply the
> patches without undue effort, and it could easily be that those applying
> the patches would then make it even easier to abuse the new channels due =
to
> laziness or poor coding choices.

I'm with Ben on this one. I also have followed the FCC actions in the past =
few=20
years, and I've also been involved into that [1,2,3]. There are mailing lis=
ts=20
on the topic if you want to get involved. I agree that the topic is importa=
nt,=20
but I would prefer to not have this patch serving as battleground. :)

The patches proposed here, as Ben says, at least put proper warnings and=20
obstacles which users have to knowingly overcome (or read). It's probably=20
safer than keeping the driver as is and having people apply random patches=
=20
from=20the internet which they don't understand or hack the code themselves.=
=20
=46rankly, it's not that hard to enable those channels.

As we have seen by the number of questions and people trying to bring this=
=20
patch in (Ben and Julian), there is quite some interest for supporting thos=
e=20
bands. I've also got a few requests from companies to have it supported=20
(Fraunhofer is one of those).

Cheers,
      Simon


[1] https://www.reddit.com/r/wireless/comments/3irr5b/
openwrt_vs_fcc_forced_firmware_lockdown/
[2] http://hackaday.com/2016/02/26/fcc-locks-down-router-firmware/
[3] https://libreplanet.org/wiki/Save_WiFi
--nextPart3889230.LO2l9a0JLG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlj57QoACgkQoSvjmEKS
nqHvDg/+K4FKaulI7jJkeAE73hV3scyNvfBuF2XpeoLNFCddM/tKv+jySGvDWoRF
dD2HSXTb42blzb5cDKJOZCbyIX4/XOOt67p5sL3WQv7Jmm7I6A/GDUb3gbp+674L
PCRHa2iTQVmX/eNt4+3yglGA5iN95NuViRwuQhiuU/rBanhyFm9mMEbHj2vJ749l
SnduztAeJS5PZL3Y7p08ilox/c7/gLNyOQI4CSFCQeJxVTeZL2iMEZyJ0L9/uFf3
zFcKwYP031sKPywA8rocfOTFTppnO4JBOOYYU384M0LMgRfEX5+6YlS1NYyzk0cZ
05UuujTgdRLizRuKA4Y+rVffPQp9a+jMVguCAT0/Hcqy/NlJX9hU8FD8O/UYeGw7
ycMP/8SMGHWchLcpe+/7t6au+it9hZDAtK+9DWbWU1+8VUBTajr5TIUvMvV+YDN4
166D9spASaPcrRXBD0NvtJYHbMQ4orpnCMSkbhUPulDtipev4xIrUOgevEwj+v1B
L+YQHXcswSF2Eh2dffzIeQB8WMx3BQ1pOu+4vBM/aItREFSdRIOV/DON5q+a/F85
1744XL1O6+EF6bhaXD7HGNRgzwdJqJTZCmIftis29EQTbWLS3GR+Ih52wTWQdyyg
qKBt4hEH/8n46lrlW4USwuhBys0ry9EUYm06mNoETQg3JKAiHOg=
=RpCw
-----END PGP SIGNATURE-----

--nextPart3889230.LO2l9a0JLG--
