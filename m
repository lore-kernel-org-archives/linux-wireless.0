Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38578 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbXI1NgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 09:36:03 -0400
Message-ID: <46FD0342.3020401@lwfinger.net>
Date: Fri, 28 Sep 2007 08:36:02 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Error in compilation of b43
References: <46FC854B.2010500@lwfinger.net> <1190979092.5021.37.camel@johannes.berg>
In-Reply-To: <1190979092.5021.37.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2007-09-27 at 23:38 -0500, Larry Finger wrote:
>=20
>> drivers/net/wireless/b43/rfkill.c:112: error: implicit declaration o=
f function =E2=80=98rfkill_get_led_name=E2=80=99
>> drivers/net/wireless/b43/rfkill.c:112: warning: return makes pointer=
 from integer without a cast
>>
>> I assume that I missed some critical patch. Can you tell me which on=
e it is?
>=20
> Looks like "[PATCH] rfkill: Add support for an rfkill LED" might be i=
t.

That patch fixed the implicit declaration of rfkill_get_led_name, but I=
 still get the other error

In file included from drivers/net/wireless/b43/rfkill.c:25:
drivers/net/wireless/b43/rfkill.h:17: error: field =E2=80=98notify_work=
=E2=80=99 has incomplete type
drivers/net/wireless/b43/rfkill.c: In function =E2=80=98b43_notify_rfki=
ll_press=E2=80=99:
drivers/net/wireless/b43/rfkill.c:31: warning: type defaults to =E2=80=98=
int=E2=80=99 in declaration of =E2=80=98__mptr=E2=80=99
drivers/net/wireless/b43/rfkill.c:31: warning: initialization from inco=
mpatible pointer type

Larry
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
