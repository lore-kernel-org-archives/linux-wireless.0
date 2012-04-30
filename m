Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:46550 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2D3MAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 08:00:38 -0400
Date: Mon, 30 Apr 2012 08:00:37 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: simple w8 <simplew8@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
Message-ID: <20120430120037.GG9863@alittletooquiet.net> (sfid-20120430_140042_547041_9306706B)
References: <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com>
 <4F9BFA14.3070008@lwfinger.net>
 <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com>
 <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com>
 <4F9DD22F.8010305@lwfinger.net>
 <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com>
 <4F9DE46E.6030103@lwfinger.net>
 <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com>
 <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com>
 <4F9DFF0A.7080604@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/unnNtmY43mpUSKx"
In-Reply-To: <4F9DFF0A.7080604@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Apr 29, 2012 at 09:55:06PM -0500, Larry Finger wrote:
> On 04/29/2012 08:11 PM, simple w8 wrote:
> >2012/4/30 simple w8<simplew8@gmail.com>:
> >>2012/4/30 Larry Finger<Larry.Finger@lwfinger.net>:
> >>>On 04/29/2012 07:51 PM, simple w8 wrote:
> >>>>
> >>>>2012/4/30 Larry Finger<Larry.Finger@lwfinger.net>:
> >>>
> >>>
> >>>>>Get
> >>>>>
> >>>>>http://linuxwireless.org/download/compat-wireless-2.6/compat-wireles=
s-2012-04-26.tar.bz2.
> >>>>>That is the "bleeding-edge" version. As I said in the previous messa=
ge,
> >>>>>it
> >>>>>will build on your kernel!
> >>>>
> >>>>
> >>>>I didnt remove any mail address i simply forgot to hit the reply all
> >>>>button.
> >>>
> >>>
> >>>That IS removing mail addresses.
> >>>
> >>>
> >>>>Previously i tried to build the subdirectory rtlwifi but that wasnt
> >>>>possible, so build the entry tree compat-wireless and installed it,
> >>>>but the problem about having repeated chars when typing and the mouse
> >>>>freeze continues happening.
> >>>>
> >>>>Now a different problem, i noticed that after kernel-3.3.1 it started
> >>>>appearing less wifi networks, where i used to detect about 10 wifi
> >>>>networks, with kernel>    3.3.1 it only detected about 2 or 3 wifi
> >>>>networks, i reported that to the distro and they said was a problem
> >>>>from upstream since they didnt had changed nothing regarding wifi, and
> >>>>after i installed compat-wireless that was solved. Im running
> >>>>kernel-3.3.4 with compat-wireless and it detects again about 10 wifi
> >>>>networks.
> >>>>
> >>>>Should i report this upstream so it can be fixed still in the
> >>>>kkkkkernel 3.3.4 serie or you ccccccan do it?
> >>>
> >>>
> >>>Whatever patch that fixed that problem will be backported to 3.3.X if =
it can
> >>>be. Not everything qualifies.
> >>>
> >>>
> >>>>By the way see how the characters "k" and "c" got repeated when i was
> >>>>typing last paragraph.
> >>>
> >>>
> >>>I see them, but they do not happen on my machine, thus I have no idea =
of the
> >>>cause. So far, you can only say that they don't happen when rtl8192ce =
is not
> >>>loaded; however, you have no network then either. The problem could be
> >>>anywhere in the network stack.
> >>>
> >>>You said earlier that you tried the Ubuntu Live system. Would it be po=
ssible
> >>>to download and try the openSUSE 12.1 Live CD as well? As you have used
> >>>Ubunbtu, you should try the Gnome version.
> >>>
> >>>Larry
> >>
> >>These are the distros that i tried so far and all presented the same
> >>problem i have described:
> >>- Mandriva
> >>- Mageia
> >>- Ubuntu
> >>- Kubuntu
> >>- Caixa Magica
> >
> >What wifi you have?
> >What distro you run?
> >Do you run NetworManager?
>=20
> You forgot the "Reply All" again!
>=20
> I run openSUSE 12.1 KDE, and I use NetworkManager.
>=20
> I have many wifi devices, including both RTL8188CE and RTL8192CE. At
> the moment, I am running an RTL8188CE, which has been up for nearly
> 100 hours without dropping the connection, and with no problems with
> the keyboard. My kernel is from wireless-testing, which means that
> my wireless stuff is exactly what you got with compat-wireless.

FWIW, I do recall seeing issues with my USB keyboard when testing with
rtl8192de.  I believe the problems went away when I disabled power manageme=
nt:

  options rtl8192de ips=3D0 swlps=3D0 fwlps=3D0

Hope this helps.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--/unnNtmY43mpUSKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk+efuUACgkQRO4fQQdv5Awf0gCgoz7HldzFNiPPgTAwnIM0HiLN
PnwAnjTCqf6Pei0OOs4QZa4mRbhyZesS
=Hu00
-----END PGP SIGNATURE-----

--/unnNtmY43mpUSKx--
