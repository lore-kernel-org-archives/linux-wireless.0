Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33641 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbYBXMni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 07:43:38 -0500
Date: Sun, 24 Feb 2008 13:35:16 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>
Cc: "R. Hofmann" <anmue@gmx.net>, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: B43legancy_warn_on - error ...???
Message-ID: <20080224133516.24d65036@morte> (sfid-20080224_124344_783050_85986017)
In-Reply-To: <200802241335.30226.mb@bu3sch.de>
References: <20080224103031.127510@gmx.net>
	<200802241335.30226.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 24 Feb 2008 13:35:29 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> On Sunday 24 February 2008 11:30:31 R. Hofmann wrote:
> > localhost:/source/compat-wireless-2.6 # make
> > make -C /lib/modules/2.6.22.5-31-default/build M=3D/source/compat-w=
ireless-2.6 modules
> > make[1]: Entering directory `/usr/src/linux-2.6.22.5-31-obj/x86_64/=
default'
> > make -C ../../../linux-2.6.22.5-31 O=3D../linux-2.6.22.5-31-obj/x86=
_64/default modules
> >   CC [M]  /source/compat-wireless-2.6/drivers/net/wireless/b43legac=
y/main.o
> > /source/compat-wireless-2.6/drivers/net/wireless/b43legacy/main.c: =
In function =E2=80=98b43legacy_ram_write=E2=80=99:
> > /source/compat-wireless-2.6/drivers/net/wireless/b43legacy/main.c:2=
36: error: implicit declaration of function =E2=80=98B43legacy_WARN_ON=E2=
=80=99
> > make[6]: *** [/source/compat-wireless-2.6/drivers/net/wireless/b43l=
egacy/main.o] Fehler 1
> > make[5]: *** [/source/compat-wireless-2.6/drivers/net/wireless/b43l=
egacy] Fehler 2
> > make[4]: *** [/source/compat-wireless-2.6/drivers/net/wireless] Feh=
ler 2
> > make[3]: *** [_module_/source/compat-wireless-2.6] Fehler 2
> > make[2]: *** [modules] Fehler 2
> > make[1]: *** [modules] Fehler 2
> > make[1]: Leaving directory `/usr/src/linux-2.6.22.5-31-obj/x86_64/d=
efault'
> > make: *** [modules] Fehler 2
> >=20
>=20
> That's pretty weird.
> Oh wait... This is the compat package, right?

This is because I'm an idiot. Patch coming soon. In the meanwhile, you =
may
want to build that with debugging enabled to solve the issue.


--
Ciao
Stefano
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
