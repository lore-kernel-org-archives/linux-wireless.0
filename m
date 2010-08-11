Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:36753 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab0HKAbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 20:31:49 -0400
Date: Tue, 10 Aug 2010 21:23:55 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?utf-8?B?R8OhYm9y?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: RTL 8187b - naughty behaviour
Message-ID: <20100811002355.GB5874@barata.holoscopio.com>
References: <4BB773A9.2070703@lwfinger.net>
 <n2n917a57cb1004031000h9910230ew50c6380788a64b1c@mail.gmail.com>
 <q2k917a57cb1004100507s17249540xfb11a2e2f0a2dd76@mail.gmail.com>
 <w2i69e28c911004101150h9db59aa1x2f9d12964f3c3fc1@mail.gmail.com>
 <y2g917a57cb1004101240g8033e225n57bf68b6d37b5431@mail.gmail.com>
 <q2k69e28c911004110635nac8100f6pe014361ed0a516a5@mail.gmail.com>
 <1275579654.1311.32.camel@casa>
 <AANLkTimKLuiLpV0C+cXOyX2OqJOwB+giVLaHKCMJKVvt@mail.gmail.com>
 <4C5F5D5C.9040709@lwfinger.net>
 <AANLkTimQtAOSjfpCx8H3RXu0O+gPbvMQQ3P3-tLmpaiV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
In-Reply-To: <AANLkTimQtAOSjfpCx8H3RXu0O+gPbvMQQ3P3-tLmpaiV@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 10, 2010 at 09:03:46PM -0300, Rogerio Luz Coelho wrote:
> lem
> 2010/8/8 Larry Finger <Larry.Finger@lwfinger.net>:
> > On 08/08/2010 05:22 PM, Rogerio Luz Coelho wrote:
> >> SNIP ...
> >>
> >> So no luck with the Realtek driver yet?
> >
> > We are not doing anything with the Realtek driver. My RTL8187B device w=
orks
> > perfectly fine.
> >
> > If you were to study a vendor driver and come up with some patches to r=
tl8187
> > that made your device function better, then I would consider them, but =
at this
> > point, I am not looking at any changes to rtl8187.
> >
> > Larry
> >
>=20
> Ok, but have you seen the amount of people on the Ubuntu bug list with
> the same problem?
>=20
> I am just saying it seems it is quite widespread problem, not just my cas=
e ...
>=20
> I tried to post all information asked, I have no idea even if  I did
> the mmio trace right since I had no response.
>=20

Hello, folks.

I've been working for some two weeks observing the behaviour of
rtl8187B. Thanks to someone's report (I think it was Rogerio's), I found
the realtek driver. It does seem to work a little better regarding
transmission. I have taken a look at the driver (it's GPLed) and done
some experiments, but couldn't find any particular difference that
magically make it work yet.

I think the mmiotrace is not exactly what you want. Since these are USB
devices, usbmon dumps are much more readable and useful. I've made some
of my own, but still need to write some scripts to translate them to
something I can read and compare more easily.

As soon as I get some patches that work for me and are field tested for
these particular device versions, I will send them to the list for
review and testing with other device versions.

Larry, you mentioned in one of your messages about the specs. Are they
under an NDA or could you provide or ask for a copy?

At a glance, the realtek driver seems to do some dynamic power gain
control. I will try this as one of my next steps.

Regards,
Cascardo.

> :)
>=20
> Hey, I am not trolling here, it=C2=B4s just I thought you guys would
> **magically** find the issue after my post (hey wishfull thinking is
> STILL thinking right?)
>=20
> Rogerio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJMYe2aAAoJEEWxSg7udFZIUCcP/202Dusn07LpFz+BXwOQDdMr
2Ueg6kJZx9WV/hWsWPo/oTWJRgrQj7QaVM1qPmNhZXFRsD53SP7eyEnGpIL07NeN
/Q3yfHuJS5SDfTPRhpklipf76tri+WAIHAhx8q4znO9RTcC8qgIBhu47qAoCvjMr
IAIzVsJ9NxB9Op9Kqr76wOn7YNJn5UsZLr90l8VFWZpjMXctoJNsiQN67+xNfTUG
A6wI1mzWW6WJGpHBTfVAqWfCY6rpliiXL+2C4/yZ58EN3ozn506C8w3cmiHY5noc
1ucRzi4N8yXt0yPzwZEBmKVFeE1gWV9Bkj/OMgTxUmnCjMm899PkCBSn+yVMhSJP
8AzDzmNtFjcgih+rRTkLg4fHPLyM1a+c+uoTpiHpBIgKsGcu16Lg6n6N4ecWQ+4E
JCWYTJEAN0XsPya3wM5pUmQKfLq+PdJIQSVH3zfhPTl69dHeLDcJ2vM9pyr2X+e4
SdhYRywz59UvdZX+/9bX55RbUB1v++M2+Uf/F/ZRmgpshlrcirf5XqZwYtUl4G8m
Ew9s30NH5iAMz69Xf6nRFcImOVo5mUonQB1GW9s+4VlObRXh5z0CVvywbyrIg95V
H7Vy7FBSBDEYqvL/j1F2NAWaF5WnEpgIx9QbT/Tum/O1Q5hcPQXljCD55T6W3VM9
xMLkZVuwV+JePNmYKRhj
=Esvf
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
