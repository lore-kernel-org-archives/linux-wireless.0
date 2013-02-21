Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:48467 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab3BUAhh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 19:37:37 -0500
Date: Thu, 21 Feb 2013 04:37:30 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
cc: devel@lists.open80211s.org, Adrian Chadd <adrian@freebsd.org>,
	ath9k-devel@lists.ath9k.org, Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <alpine.DEB.2.02.1302202327450.2057@icf.org.ru>
Message-ID: <alpine.DEB.2.02.1302210432480.22701@icf.org.ru> (sfid-20130221_013743_135047_190094DD)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru> <20130219134028.GA26332@pandem0nium> <alpine.DEB.2.02.1302191752110.31254@icf.org.ru> <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com> <alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
 <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com> <20771.50338.434076.484711@gargle.gargle.HOWL> <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com> <20771.51233.248133.141840@gargle.gargle.HOWL>
 <alpine.DEB.2.02.1302192258510.19584@icf.org.ru> <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com> <alpine.DEB.2.02.1302200027120.19533@icf.org.ru> <CAEFj9871wuavGjjs=KRPK0Wq3gxeOxLP_Az6OU7LAJFw+W=6-g@mail.gmail.com>
 <alpine.DEB.2.02.1302202327450.2057@icf.org.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-284047418-1361407050=:22701"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-284047418-1361407050=:22701
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-20 23:31 +0400, Georgiewskiy Yuriy wrote Yeoh Chun-Yeow:

GY>On 2013-02-20 11:30 +0800, Yeoh Chun-Yeow wrote devel@lists.open80211s.org:
GY>
GY>YC>> but, there is some funny rssi processing sometimes:
GY>YC>>
GY>YC>>
GY>YC>>         /* Update Beacon RSSI, this is used by ANI. */
GY>YC>>         ah->stats.avgbrssi = rssi;
GY>YC>>
GY>YC>> may be i don't understand something, but looks strange.
GY>YC>
GY>YC>If I am not mistaken, mesh node (802.11s) does not process beacon RSSI in ath9k,
GY>
GY>Yes, you are right, 802.11s not hit this code path, but there is people who use ibss
GY>and seems have problems with ani too.

hm, but ibss not hit this path too because is_mybeacon is 0 in this mode, 
seems this works only for station mode.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-284047418-1361407050=:22701--
