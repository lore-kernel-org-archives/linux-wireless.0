Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:36577 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758790AbdAJIVN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 03:21:13 -0500
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Subject: Re: kernel 4.9 iwlwifi startup error
Date: Tue, 10 Jan 2017 09:21:10 +0100
Message-ID: <2231220.vMvt4J1trM@calvin> (sfid-20170110_092130_823306_896CE0CF)
In-Reply-To: <1484000511.5227.33.camel@coelho.fi>
References: <2029482.jt8IarKZJs@calvin> <942b4775-6027-2b99-84c7-37b7cde124b9@au1.ibm.com> <1484000511.5227.33.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In data marted=EC 10 gennaio 2017 00:21:51 CET, Luca Coelho ha scritto:
> On Tue, 2017-01-03 at 13:42 +1100, Andrew Donnellan wrote:
> > On 02/01/17 21:12, Fabio Coatti wrote:
> > > Hi all,
> > > I'm using kernel 4.9 and maybe half of the times I boot my laptop I g=
et
> > > the
> > > error reported below, and the wifi does not work. I have to remove
> > > iwlwifi (like modprobe -r iwldvm iwlwifi) and insert it again to get
> > > things workig again. This seems a bit random, it does not happens all
> > > the times so it could be a timing issue or even a flaky hardware
> > > (unlikely, as I see only this issue with wifi, once it starts it works
> > > just fine)
> > > I'm pretty sure to have seen the same behaviour at some point in 4.8.X
> > > release, but right now I lost the related notes.
> > > Environment:
> > > Distro: gentoo
> > > gcc 5.4.0
> > > HW: Hewlett-Packard HP EliteBook Folio 9470m/18DF, BIOS 68IBD Ver. F.=
63
> > > 04/26/2016
> > > Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz
> > > Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 2=
4)
> > >=20
> > > Of course if more info is needed, just drop me a note.
> > >=20
> > > I'm not subscribed to mailing lists, so please keep me in CC: for any
> > > information request.
> > >=20
> > > Many thanks.
> >=20
> > I've so far seen this once on my laptop, a Samsung NP540U3C (don't have
> > it with me right now, so I'm not sure what the wifi chipset is), running
> > with a Debian 4.9 kernel.
>=20
> This bug has already been reported in bugzilla:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D190281
>=20
> Did you have any problems with older kernel versions? If so, would it be
> possible for you to bisect?


Well, it happens on a laptop that I use quite intensively, so it will take=
=20
some time to bisect. However, in the meantime I checked the old logs and th=
e=20
first recorded occurrence happened with 4.8.10 release and firmware version=
=20
18.168.6.1


=2D-=20
=46abio
