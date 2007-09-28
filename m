Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:59576 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757490AbXI1Eir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 00:38:47 -0400
Message-ID: <46FC854B.2010500@lwfinger.net>
Date: Thu, 27 Sep 2007 23:38:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Error in compilation of b43
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

When I add your patch "b43: RF-kill support" to my source, I get the fo=
llowing compilation error:

  CC [M]  drivers/net/wireless/b43/rfkill.o
In file included from drivers/net/wireless/b43/rfkill.c:25:
drivers/net/wireless/b43/rfkill.h:17: error: field =E2=80=98notify_work=
=E2=80=99 has incomplete type
drivers/net/wireless/b43/rfkill.c: In function =E2=80=98b43_notify_rfki=
ll_press=E2=80=99:
drivers/net/wireless/b43/rfkill.c:31: warning: type defaults to =E2=80=98=
int=E2=80=99 in declaration of =E2=80=98__mptr=E2=80=99
drivers/net/wireless/b43/rfkill.c:31: warning: initialization from inco=
mpatible pointer type
drivers/net/wireless/b43/rfkill.c: In function =E2=80=98b43_rfkill_led_=
name=E2=80=99:
drivers/net/wireless/b43/rfkill.c:112: error: implicit declaration of f=
unction =E2=80=98rfkill_get_led_name=E2=80=99
drivers/net/wireless/b43/rfkill.c:112: warning: return makes pointer fr=
om integer without a cast

I assume that I missed some critical patch. Can you tell me which one i=
t is?

Thanks,

Larry
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
