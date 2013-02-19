Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:38650 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932835Ab3BSSiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 13:38:55 -0500
Date: Tue, 19 Feb 2013 22:38:52 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Adrian Chadd <adrian@freebsd.org>
cc: Sujith Manoharan <sujith@msujith.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302192236090.9244@icf.org.ru> (sfid-20130219_193901_083323_889CE442)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru> <20130219134028.GA26332@pandem0nium> <alpine.DEB.2.02.1302191752110.31254@icf.org.ru> <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com> <alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
 <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com> <20771.50338.434076.484711@gargle.gargle.HOWL> <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-493343660-1361299132=:9244"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-493343660-1361299132=:9244
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-19 10:33 -0800, Adrian Chadd wrote Sujith Manoharan:

AC>It's easy enough to diagnose - just enable NF cal logging. Look at
AC>what's being read back from the initial NF cal and what's being
AC>written into the time-series average.
AC>
AC>It may be that something dumb is happening, like there's no
AC>per-channel history, or the history from the wrong channel is being
AC>used on a new channel.
AC>
AC>I know the reference driver has a couple of options (per-channel NF
AC>history or shared NF history with a "scan" not using the history
AC>buffer..)

i do this already, in my case i dont see anything strange on NF claibration.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-493343660-1361299132=:9244--
