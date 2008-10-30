Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:49943 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYJ3Cub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 22:50:31 -0400
Received: by rv-out-0506.google.com with SMTP id k40so339253rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 19:50:31 -0700 (PDT)
Subject: compile problems
From: jon doe <mass.of.doughnuts@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Wed, 29 Oct 2008 19:49:25 -0700
Message-Id: <1225334965.25716.1.camel@indika.weed.com> (sfid-20081030_035038_410087_059914E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

please help

heres the error

make -C /lib/modules/2.6.27.3-indika/build
M=3D/home/jon/compat-wireless-2008-10-29 modules
make[1]: Entering directory `/usr/src/linux-2.6.27.3'
  CC      /home/jon/compat-wireless-2008-10-29/net/mac80211/main.o
/home/jon/compat-wireless-2008-10-29/net/mac80211/main.c: In function
=E2=80=98ieee80211_handle_filtered_frame=E2=80=99:
/home/jon/compat-wireless-2008-10-29/net/mac80211/main.c:435: error:
=E2=80=98struct sk_buff=E2=80=99 has no member named =E2=80=98requeue=E2=
=80=99
/home/jon/compat-wireless-2008-10-29/net/mac80211/main.c:437: error:
=E2=80=98struct sk_buff=E2=80=99 has no member named =E2=80=98requeue=E2=
=80=99
make[3]: *** [/home/jon/compat-wireless-2008-10-29/net/mac80211/main.o]
Error 1
make[2]: *** [/home/jon/compat-wireless-2008-10-29/net/mac80211] Error =
2
make[1]: *** [_module_/home/jon/compat-wireless-2008-10-29] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.27.3'
make: *** [modules] Error 2


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
