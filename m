Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43192 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYBXMgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 07:36:03 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "R. Hofmann" <anmue@gmx.net>
Subject: Re: B43legancy_warn_on - error ...???
Date: Sun, 24 Feb 2008 13:35:29 +0100
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <20080224103031.127510@gmx.net>
In-Reply-To: <20080224103031.127510@gmx.net>
MIME-Version: 1.0
Message-Id: <200802241335.30226.mb@bu3sch.de> (sfid-20080224_123619_473840_916EF2DC)
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 February 2008 11:30:31 R. Hofmann wrote:
> localhost:/source/compat-wireless-2.6 # make
> make -C /lib/modules/2.6.22.5-31-default/build M=3D/source/compat-wir=
eless-2.6 modules
> make[1]: Entering directory `/usr/src/linux-2.6.22.5-31-obj/x86_64/de=
fault'
> make -C ../../../linux-2.6.22.5-31 O=3D../linux-2.6.22.5-31-obj/x86_6=
4/default modules
>   CC [M]  /source/compat-wireless-2.6/drivers/net/wireless/b43legacy/=
main.o
> /source/compat-wireless-2.6/drivers/net/wireless/b43legacy/main.c: In=
 function =E2=80=98b43legacy_ram_write=E2=80=99:
> /source/compat-wireless-2.6/drivers/net/wireless/b43legacy/main.c:236=
: error: implicit declaration of function =E2=80=98B43legacy_WARN_ON=E2=
=80=99
> make[6]: *** [/source/compat-wireless-2.6/drivers/net/wireless/b43leg=
acy/main.o] Fehler 1
> make[5]: *** [/source/compat-wireless-2.6/drivers/net/wireless/b43leg=
acy] Fehler 2
> make[4]: *** [/source/compat-wireless-2.6/drivers/net/wireless] Fehle=
r 2
> make[3]: *** [_module_/source/compat-wireless-2.6] Fehler 2
> make[2]: *** [modules] Fehler 2
> make[1]: *** [modules] Fehler 2
> make[1]: Leaving directory `/usr/src/linux-2.6.22.5-31-obj/x86_64/def=
ault'
> make: *** [modules] Fehler 2
>=20

That's pretty weird.
Oh wait... This is the compat package, right?

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
