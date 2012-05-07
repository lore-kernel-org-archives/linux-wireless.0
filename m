Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:38399 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755225Ab2EGXcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 19:32:31 -0400
Received: from mail95.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo2.mail-out.ovh.net (Postfix) with SMTP id 9B03FDC2FD7
	for <linux-wireless@vger.kernel.org>; Tue,  8 May 2012 01:16:48 +0200 (CEST)
Subject: Re: Is there a patch for a bug?
From: Jean-Philippe MENGUAL <mengualjeanphi@free.fr>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4F698F7E.9030906@broadcom.com>
References: <1332265928.7247.1.camel@HP>  <4F698F7E.9030906@broadcom.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jTITE9t11AH7121BhjDs"
Date: Tue, 08 May 2012 01:15:11 +0200
Message-Id: <1336432511.3988.6.camel@HP> (sfid-20120508_013241_790919_9FDD45D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jTITE9t11AH7121BhjDs
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Sorry to answer so late, but I had few time to do tests recently.
Actually it seemed to work. The conditions of success are somewhat
strange: sometimes I've to reboot and re-t!y so that the dhclient works,
but... well.

Well, so it worked, until today. I get this today:
wl0: wlc_wme_setparams : no-clock

On kernel 2.6.32, when I do iwlist scan then, the computer freezes
fully. Really fully. The hardware crashes (RAM, CPU, etc.). On a 3.2.0
kernel, it doesn't, but wlan0 says that no scan possible as network not
available. My laptop is a HP ProBook 6560b (LG652ET)

Do you know such problem and any solution? Do you think it can be a
hardware problem? I don't understand why my wifi would be locked, as I
haven't done anything for that and I don't know how to achieve this. But
I can try some unlock if you tell me the shortcut. Finally, a Debian Dev
suggested me, a long time ago, a software to check locking and control
locking of bluetooth/wifi hardware, but I don't remember it.

Thanks for your help and I'm now more available to test and tweak if
needed.

Regards,


Jean-Philippe MENGUAL


Le mercredi 21 mars 2012 =E0 09:21 +0100, Arend van Spriel a =E9crit :
> On 03/20/2012 06:52 PM, Jean-Philippe MENGUAL wrote:
> > Hi,
> >
> >          I use the 2.6.32 kernel on a Debian system. I use the module
> >          mac80211 for my Wifi card. But in more and more numerous cases=
,
> >          I cannot get an IP with dhclient. It fails. While it searches
> >          for one, I get:
> >          wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 366/186
> >
> >          Is it a bug in the module? I found some info but not about som=
e
> >          patch or fix. Is there a fix in the recent kernel? What releas=
e
> >          should I use? If no patch, is there some workaround?
> >
> >          Thanks,
> >
> >          Sincerely,
> >
> > Jean-Philippe MENGUAL
> >
>=20
> The message itself means that according to the driver we get a transmit=20
> packet that exceeds the WMM txop. This message itself does not prevent=20
> the packet from being transmitted. I have not seen the message lately in=20
> recent driver versions.
>=20
> You can either try compat-wireless (see [1]), which should support=20
> 2.6.32. Or you can try the latest 3.3 kernel.
>=20
> btw. 9 out of 10 times not getting an IP with dhclient means a problem=20
> with security credentials/handshake/etc. So if the option above do not=20
> solve your problems, we have to dive into that.
>=20
> Gr. AvS
>=20
> [1] http://linuxwireless.org/en/users/Download
>=20

--=-jTITE9t11AH7121BhjDs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJPqFd6AAoJEJ3UrG5CoODatNwP/jd0f6leVeK1a814fuKwloRG
FwSO1hUSqcGl6YyGH5Qx4wBw6RqmONuzX03z1Qsd/rxpt6fqHzuqK98/IiDIeSDP
YImeG9DoR3xKcDHQ8rqUWP6ZxqZV8xk2bgaQ8ssNo03Jv1zz8iG+zRSKijojIW42
15QyLVvW4hS/KOvNkd7sNAKW9wjkIOXr8syq0gzazE4GDZ6zqL5N4BV5BPRmefZR
rHneb8Ho4PVKfG81aq8NBtApf4Dlr86F/MiAkOB2a0gXC9BLLEFafaXrbGv14EZS
e9eFcyIUlya0CG2b/tk1kR34Fugynkha8KvzM/0ZxEsmEXz9BTk4+P36rgWXJP4n
SexaLynCAJVrXOZSoz4Si/MKoD/7ySchZCCK15gFwY4qMPpxVjBxXfs+fUdNUi1l
N/JUbVZm16cT1GkWgT/QPlenFeE3DTtVVVg4tEHZc4+ceWX1huod3WQikVIde11q
kgw1HGNwyhsadxm5xouPRbX/m0BTlwN7UnejQ9CkaleXQKMc5r6eHWQ+End1TDYO
tqS+wVNrfIQPx9P7jdXRnDi6x/KjyJJ27aEzhKvtINjPiT6C5pJFxDxwdlsCG08u
6rBaukwQvXLQGk6WVOwAOw0FXUOy4LPT1c0OMvzbRn+3Oin8GEuYWkeLpyEet4S4
1rPUcF9KKOvwBPQsv5pk
=Ojw0
-----END PGP SIGNATURE-----

--=-jTITE9t11AH7121BhjDs--

