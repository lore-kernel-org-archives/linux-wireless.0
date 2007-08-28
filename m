Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.goshen.edu ([199.8.232.22]:37409 "EHLO mail.goshen.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXH1OkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 10:40:22 -0400
Received: from jesseas.goshen.edu (jesseas.goshen.edu [199.8.237.234])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.goshen.edu (Postfix) with ESMTP id 2EF0551C080
	for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2007 10:26:43 -0400 (EDT)
From: Jesse Shaver <J_shaver@comcast.net>
To: linux-wireless@vger.kernel.org
Subject: mac80211 problems
Date: Tue, 28 Aug 2007 10:25:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200708281025.50899.J_shaver@comcast.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All;
I am sorry for bothering this dev list with this question, but I can't =
seem to=20
find an answer anywhere else...

I am trying to get my Intel 4965AGN wireless to work under SuSE 10.2 (6=
4bit)=20
no a Lenovo X61 Core duo 2. I am trying to build mac80211 for it, but a=
m=20
getting errors.=20

my kernel is:
hayden:~/mac80211-9.0.4 # uname -a
Linux hayden 2.6.18.8-0.5-default #1 SMP Fri Jun 22 12:17:53 UTC 2007 x=
86_64=20
x86_64 x86_64 GNU/Linux

The error I get is:

net/mac80211/ieee80211_sta.c: In function =E2=80=98sta_process_csa=E2=80=
=99:
net/mac80211/ieee80211_sta.c:2546: warning: format =E2=80=98%d=E2=80=99=
 expects type =E2=80=98int=E2=80=99,=20
but argument 2 has type =E2=80=98size_t=E2=80=99
  CC [M]  net/mac80211/ieee80211_iface.o
  CC [M]  net/mac80211/ieee80211_rate.o
  CC [M]  net/mac80211/michael.o
  CC [M]  net/mac80211/regdomain.o
  CC [M]  net/mac80211/tkip.o
  CC [M]  net/mac80211/aes_ccm.o
  CC [M]  net/mac80211/wme.o
  CC [M]  net/mac80211/ieee80211_cfg.o
  CC [M]  net/mac80211/ieee80211_led.o
  CC [M]  net/mac80211/debugfs.o
net/mac80211/debugfs.c: In function =E2=80=98mac80211_open_file_generic=
=E2=80=99:
net/mac80211/debugfs.c:28: error: =E2=80=98struct inode=E2=80=99 has no=
 member=20
named =E2=80=98i_private=E2=80=99
make[2]: *** [net/mac80211/debugfs.o] Error 1
make[1]: *** [net/mac80211] Error 2
make: *** [net] Error 2

I do have some programming background, but very little in C/C++ and onl=
y=20
limited kernel compiling experience.

thanks for any help you can give, sorry to bother you all.

-Jesse Shaver
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
