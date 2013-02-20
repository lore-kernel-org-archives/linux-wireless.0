Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:56743 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934854Ab3BTTzT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 14:55:19 -0500
Date: Wed, 20 Feb 2013 23:55:14 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Bob Copeland <me@bobcopeland.com>
cc: devel@lists.open80211s.org, Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <20130220142401.GA21725@localhost>
Message-ID: <alpine.DEB.2.02.1302202351280.2057@icf.org.ru> (sfid-20130220_205524_857147_86A45124)
References: <alpine.DEB.2.02.1302191752110.31254@icf.org.ru> <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com> <alpine.DEB.2.02.1302192034420.7450@icf.org.ru> <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
 <20771.50338.434076.484711@gargle.gargle.HOWL> <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com> <20771.51233.248133.141840@gargle.gargle.HOWL> <alpine.DEB.2.02.1302192258510.19584@icf.org.ru> <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com>
 <alpine.DEB.2.02.1302200027120.19533@icf.org.ru> <20130220142401.GA21725@localhost>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-1765695975-1361390114=:2057"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-1765695975-1361390114=:2057
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-20 09:24 -0500, Bob Copeland wrote devel@lists.open80211s.org:

BC>On Wed, Feb 20, 2013 at 12:31:13AM +0400, Georgiewskiy Yuriy wrote:
BC>> common.h
BC>> #define ATH_EP_RND(x, mul)                                              \
BC>>         ((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
BC>
BC>Hmm, is that the same as:
BC>
BC>    (x + mul/2) / mul?

i think yes, but i dont understand what exactly do this signal processing and why it needed,
i find the source of this changes - http://www.spinics.net/lists/linux-wireless/msg35905.html, 
but there is no explain too.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-1765695975-1361390114=:2057--
