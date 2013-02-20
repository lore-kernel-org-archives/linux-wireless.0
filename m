Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173007pub.verizon.net ([206.46.173.7]:32872 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935134Ab3BTUxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 15:53:13 -0500
Received: from odin.tremily.us ([unknown] [72.68.84.219])
 by vms173007.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MIJ0060RB7QKS40@vms173007.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Wed, 20 Feb 2013 13:52:44 -0600 (CST)
Date: Wed, 20 Feb 2013 14:52:37 -0500
From: "W. Trevor King" <wking@tremily.us>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: brcmsmac and AP mode
Message-id: <20130220195237.GO14102@odin.tremily.us> (sfid-20130220_215317_017810_1A769C16)
References: <1360604039.1559.44.camel@dcbw.foobar.com>
 <511940E6.7010303@hauke-m.de> <20130220173315.GK14102@odin.tremily.us>
 <512523EF.6040703@hauke-m.de>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=0kRkyLZR5zsR9u2P
In-reply-to: <512523EF.6040703@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0kRkyLZR5zsR9u2P
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 20, 2013 at 08:28:47PM +0100, Hauke Mehrtens wrote:
> brcmsmac does not support AP mode, in [1] I was talking about b43,
> here I am talking about planing to add AP mode to brcmsmac, there is
> currently no code available.

Thanks.  Looking through the post again, it is pretty clear you were
talking about b43; I just got confused after a bunch of reading :p.

I know absolutely nothing about wireless modules at the moment, but
I'm happy to help/test/=E2=80=A6.  I'll start reading through the source for
b43 and brcmsmac, but if anyone wants to shed some light on a useful
direction, I'd appreciate it.

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--0kRkyLZR5zsR9u2P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJSmDAAoJEEUbTsx0l5OMKgsP/27OUv7Pwm5jJRIsqTAu1Pum
+UrfHCeVygJOyiRVjoD6BlOxE/1q4VSTBuBoPNrEPMgDwMgYhiK31mInwufydRPi
Sody+fxbsDEpaYoKTNL6MOKbDdZMs32y/wP4b917XpVyZuP8k8WrmDRTz3xBCJVN
fkO3egedoQ7a4Nd0hQiQcg0ST3HVacA1bRi+/IhfK8KjXlTRaOVKXAUHmsjlm7T5
dyACtFiSnDuO6IF+YvNMEGTztmMiucf+nn797c4vvonRncHA3f0yFJLjkjrMiPO9
G5jwD9qXvXmhZpr19y1vKtoLzmBQnFREs3g4w0jczzu7JcNQZFmB1coGMu8OPw7Q
39ZOpKtisEJQiR/Ei1GQ9IXqSVWrQtaCX+YnidT/FOAvdnQkTvXSG+tVqX3fOs7J
FD9/lpn3T+E44J3+TqV5q/vl9QpxbM7z2I4vvQa0a4P7A8ohtVFZiKf4mhJyvVMA
gC9tCFx4jqbZ8bZmt+DqlwT1e0h07XMiErpFAsnlO6FmzvjO9580LBGIQwmcj26v
la4xyYObZ/fYuEXQDB79OHn2Ca7JUtCPEL8hPoIN3GyZPtgS6y+d3iKQ1ExiCiwj
BtrlMGcUYhCkjYUhvqV/C8AbIB8M5HiId9QgozhQLu3Ltt5O+MVkzGg9+63Duy9Q
3kus3QFsFVJ5ZCJc3O+a
=dqkW
-----END PGP SIGNATURE-----

--0kRkyLZR5zsR9u2P--
