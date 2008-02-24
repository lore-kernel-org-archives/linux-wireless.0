Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38854 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752713AbYBXKac (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 05:30:32 -0500
Content-Type: text/plain; charset=utf-8
Date: Sun, 24 Feb 2008 11:30:31 +0100
From: "R. Hofmann" <anmue@gmx.net>
Message-ID: <20080224103031.127510@gmx.net> (sfid-20080224_103047_375208_FE1D1300)
MIME-Version: 1.0
Subject: B43legancy_warn_on - error ...???
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

localhost:/source/compat-wireless-2.6 # make
make -C /lib/modules/2.6.22.5-31-default/build M=3D/source/compat-wirel=
ess-2.6 modules
make[1]: Entering directory `/usr/src/linux-2.6.22.5-31-obj/x86_64/defa=
ult'
make -C ../../../linux-2.6.22.5-31 O=3D../linux-2.6.22.5-31-obj/x86_64/=
default modules
  CC [M]  /source/compat-wireless-2.6/drivers/net/wireless/b43legacy/ma=
in.o
/source/compat-wireless-2.6/drivers/net/wireless/b43legacy/main.c: In f=
unction =E2=80=98b43legacy_ram_write=E2=80=99:
/source/compat-wireless-2.6/drivers/net/wireless/b43legacy/main.c:236: =
error: implicit declaration of function =E2=80=98B43legacy_WARN_ON=E2=80=
=99
make[6]: *** [/source/compat-wireless-2.6/drivers/net/wireless/b43legac=
y/main.o] Fehler 1
make[5]: *** [/source/compat-wireless-2.6/drivers/net/wireless/b43legac=
y] Fehler 2
make[4]: *** [/source/compat-wireless-2.6/drivers/net/wireless] Fehler =
2
make[3]: *** [_module_/source/compat-wireless-2.6] Fehler 2
make[2]: *** [modules] Fehler 2
make[1]: *** [modules] Fehler 2
make[1]: Leaving directory `/usr/src/linux-2.6.22.5-31-obj/x86_64/defau=
lt'
make: *** [modules] Fehler 2

--=20
Psst! Geheimtipp: Online Games kostenlos spielen bei den GMX Free Games=
!=20
http://games.entertainment.web.de/de/entertainment/games/free
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
