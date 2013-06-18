Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:50266 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab3FRHyv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 03:54:51 -0400
Message-ID: <1371542085.7163.15.camel@mattotaupa> (sfid-20130618_095454_193912_4C75D739)
Subject: Re: Connection not established with Realtek RTL8188CUS based USB
 device (EDIMAX)
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Jun 2013 09:54:45 +0200
In-Reply-To: <51BF8B8D.3030603@lwfinger.net>
References: <1371326265.9845.54.camel@mattotaupa>
	 <51BCD7BA.1040900@lwfinger.net> <1371505124.8902.72.camel@mattotaupa>
	 <51BF8B8D.3030603@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kcF49viy7J/WXqQn1xvA"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kcF49viy7J/WXqQn1xvA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Montag, den 17.06.2013, 17:19 -0500 schrieb Larry Finger:
> On 06/17/2013 04:38 PM, Paul Menzel wrote:
> > What am I doing wrong?
>=20
> Did you do the 'sudo make install' step? If not, you are going to be mixi=
ng=20
> modules from the original kernel and those from backports.

No, I did not run that, hoping to avoid getting non-packaged stuff
installed. Sorry, for leaving that out.

> I just built that version of backports and installed it. Unfortunately, t=
he=20
> patches you need are not in that version as they have just been incorpora=
ted in=20
> 3.10-rc6.

Good to know. Thanks.

> They will be propagated to stable in the next few weeks, but they are=20
> not there yet. To fix that, copy the attached patch to the backports dire=
ctory=20
> and run the command
>=20
> patch -p1 < patch_5b8df24e22e0
>=20
> and remake the drivers.

I am going to try that.

Three more questions regarding this patch.

1. Could you add `CC: stable@vger.kernel.org` to the patch so it gets
backported to the stable Linux kernel releases.

2. Does this fix a regression or did it never work with WEP/WPA(1)
networks before?

3. If wpa_supplicant only prints WPA to `/var/log/syslog`, can I be sure
this is *no* WPA2 network? Because I always thought this is a WPA2
network.


Thanks,

Paul

--=-kcF49viy7J/WXqQn1xvA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlHAEkUACgkQPX1aK2wOHVgJUwCfSzNO1cQhxzKQpd80nQ3mmy4e
W64AoIHnHrAYkwTOsHAm+2Q9goU3IO0l
=fLan
-----END PGP SIGNATURE-----

--=-kcF49viy7J/WXqQn1xvA--

