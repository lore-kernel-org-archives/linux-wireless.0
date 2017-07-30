Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:32942 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbdG3LG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Jul 2017 07:06:29 -0400
Date: Sun, 30 Jul 2017 12:24:04 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        b43-dev@lists.infradead.org, kvalo@codeaurora.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43legacy: Fix a sleep-in-atomic bug in
 b43legacy_attr_interfmode_store
Message-ID: <20170730122404.63efba2c@wiggum> (sfid-20170730_130648_109503_390C65B0)
In-Reply-To: <5930BCD6.9010306@163.com>
References: <1496226547-5921-1-git-send-email-baijiaju1990@163.com>
        <85905124-7167-aeb0-8aff-4ceec09e9542@lwfinger.net>
        <592F6843.9000204@163.com>
        <20170601101113.6dd30d6d@lwn.net>
        <5930BCD6.9010306@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/o===srDRiiW1PDtn2cFa5Ky"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/o===srDRiiW1PDtn2cFa5Ky
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 02 Jun 2017 09:18:14 +0800
Jia-Ju Bai <baijiaju1990@163.com> wrote:

> On 06/02/2017 12:11 AM, Jonathan Corbet wrote:
> > On Thu, 01 Jun 2017 09:05:07 +0800
> > Jia-Ju Bai<baijiaju1990@163.com>  wrote:
> > =20
> >> I admit my patches are not well tested, and they may not well fix the =
bugs.
> >> I am looking forward to opinions and suggestions :) =20
> > May I politely suggest that sending out untested locking changes is a
> > dangerous thing to do?  You really should not be changing the locking i=
n a
> > piece of kernel code without understanding very well what the lock is
> > protecting and being able to say why your changes are safe.  Without th=
at,
> > the risk of introducing subtle bugs is very high.
> >
> > It looks like you have written a useful tool that could help us to make
> > the kernel more robust.  If you are interested in my suggestion, I would
> > recommend that you post the sleep-in-atomic scenarios that you are
> > finding, but refrain from "fixing" them in any case where you cannot of=
fer
> > a strong explanation of why your fix is correct.
> >
> > Thanks for working to find bugs in the kernel!
> >
> > jon =20
> Hi,
>=20
> Thanks for your good and helpful advice. I am sorry for my improper patch=
es.
> I will only report bugs instead of sending improper patches when I have=20
> no good solution of fixing the bugs.


Is somebody still working on these fixes?
I think I found my old b43-legacy based 4306, so that I will
be able to get these patches into properly tested shape.

--=20
Michael

--Sig_/o===srDRiiW1PDtn2cFa5Ky
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAll9s8QACgkQ9TK+HZCN
iw7bmg/9GbO+izZ4mMTv991NLq8nG53lQ+CEFsML4CAl8fkwawrFOUAgKNu5sgX7
TrXTrmym+355axVwWDy6ovV6iiU9jNoi8qko+7S2UxVwu7QRDbKyPRBQcxMLLxWX
9koq1jhuBWbwDjbLVJ8NivcfuEUltB/5ZUvtxKf73uLoBm0Zo/AR7VbAk36RVnoi
LvRFFRDJIz3gDDBTj6ABXKo2AETbY3e5DSaNTI0EhMdQ7EXoVGkY1wgYs90Mwget
PnSWM9M5CsKvr7pvsnPjSvDi3v5rlYmPCYMR3qz1puhFOihgY5Erd0E500KxjVwY
74mgNAJ9382ixg6CWwjhG2kIW8QUC78EMxnCXSp3CRXsAYGRLwzw6Lk4Q2lUOFsD
GWSOwF/5V20GnQ6NtElS6VSfpd9mDIFqbGQGaA+OckPRBGyemeeU38ERSYQeLeVf
BXJufN51Rme/cOlf6VJHoC1MvOVDKqzLibzJ0mqvTiGTbXfhFsyy+3YVqQHWAotL
cx/CiPQd2SJfIK+5PXAK5j67+VivWr9XUUjKNmCVrt3ItjJhZpnf0YB+7EMiQE09
42E6vPOtO50JbCGi8+z+Ec042heUaD9Km7CaroNpLS3I9n7MrJyZ6md2/jxY9Ess
6zMsHLrmImFknkm7Lx2baCt3vbaXag/WALw+KrXxL0Q9xUGUbow=
=BqBB
-----END PGP SIGNATURE-----

--Sig_/o===srDRiiW1PDtn2cFa5Ky--
