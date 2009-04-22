Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:48031 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZDVIHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 04:07:05 -0400
Received: by qyk16 with SMTP id 16so1924240qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 01:07:02 -0700 (PDT)
Subject: compat-wireless-2.6.-old won't compile
From: Laruin d'Volts <email.port25@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Date: Wed, 22 Apr 2009 02:55:25 -0500
Message-Id: <1240386925.2821.1.camel@debian> (sfid-20090422_100710_184507_A6E3E864)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OS: Debian Lenny

some1@localhost:~/Desktop/compat-wireless-2.6-old$ make
make -C /lib/modules/2.6.26-1-686/build
M=3D/home/some1/Desktop/compat-wireless-2.6-old modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.26-1-686'
  CC [M]  /home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.=
o
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:594:
error: redefinition of =E2=80=98ieee80211_install_qdisc=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:39:
error: previous definition of =E2=80=98ieee80211_install_qdisc=E2=80=99=
 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:614:
error: redefinition of =E2=80=98ieee80211_qdisc_installed=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:42:
error: previous definition of =E2=80=98ieee80211_qdisc_installed=E2=80=99=
 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:620:
error: redefinition of =E2=80=98ieee80211_wme_register=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:59:
error: previous definition of =E2=80=98ieee80211_wme_register=E2=80=99 =
was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:626:
error: redefinition of =E2=80=98ieee80211_wme_unregister=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:63:
error: previous definition of =E2=80=98ieee80211_wme_unregister=E2=80=99=
 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:632:
error: redefinition of =E2=80=98ieee80211_ht_agg_queue_add=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:47:
error: previous definition of =E2=80=98ieee80211_ht_agg_queue_add=E2=80=
=99 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:673:
error: redefinition of =E2=80=98ieee80211_ht_agg_queue_remove=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:53:
error: previous definition of =E2=80=98ieee80211_ht_agg_queue_remove=E2=
=80=99 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:690:
error: redefinition of =E2=80=98ieee80211_requeue=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:56:
error: previous definition of =E2=80=98ieee80211_requeue=E2=80=99 was h=
ere
make[3]: ***
[/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.o] Error =
1
make[2]: *** [/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211]
Error 2
make[1]: *** [_module_/home/some1/Desktop/compat-wireless-2.6-old] Erro=
r
2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.26-1-686'
make: *** [modules] Error 2
some1@localhost:~/Desktop/compat-wireless-2.6-old$ make
make -C /lib/modules/2.6.26-1-686/build
M=3D/home/some1/Desktop/compat-wireless-2.6-old modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.26-1-686'
  CC [M]  /home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.=
o
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:594:
error: redefinition of =E2=80=98ieee80211_install_qdisc=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:39:
error: previous definition of =E2=80=98ieee80211_install_qdisc=E2=80=99=
 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:614:
error: redefinition of =E2=80=98ieee80211_qdisc_installed=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:42:
error: previous definition of =E2=80=98ieee80211_qdisc_installed=E2=80=99=
 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:620:
error: redefinition of =E2=80=98ieee80211_wme_register=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:59:
error: previous definition of =E2=80=98ieee80211_wme_register=E2=80=99 =
was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:626:
error: redefinition of =E2=80=98ieee80211_wme_unregister=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:63:
error: previous definition of =E2=80=98ieee80211_wme_unregister=E2=80=99=
 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:632:
error: redefinition of =E2=80=98ieee80211_ht_agg_queue_add=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:47:
error: previous definition of =E2=80=98ieee80211_ht_agg_queue_add=E2=80=
=99 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:673:
error: redefinition of =E2=80=98ieee80211_ht_agg_queue_remove=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:53:
error: previous definition of =E2=80=98ieee80211_ht_agg_queue_remove=E2=
=80=99 was here
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.c:690:
error: redefinition of =E2=80=98ieee80211_requeue=E2=80=99
/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.h:56:
error: previous definition of =E2=80=98ieee80211_requeue=E2=80=99 was h=
ere
make[3]: ***
[/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211/wme.o] Error =
1
make[2]: *** [/home/some1/Desktop/compat-wireless-2.6-old/net/mac80211]
Error 2
make[1]: *** [_module_/home/some1/Desktop/compat-wireless-2.6-old] Erro=
r
2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.26-1-686'
make: *** [modules] Error 2
some1@localhost:~/Desktop/compat-wireless-2.6-old$=20

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
