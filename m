Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:48409 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3CBI0h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 03:26:37 -0500
Date: Sat, 2 Mar 2013 12:26:34 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Adrian Chadd <adrian@freebsd.org>
cc: Sujith Manoharan <sujith@msujith.org>,
	Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
In-Reply-To: <CAJ-Vmokn4A7nQdOHa4iJU=mP6_VEfHn8nYB1fsDiUhbZ1Z2mwQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1303021225100.20413@icf.org.ru> (sfid-20130302_092641_851494_679230F6)
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL> <511508A6.8020104@openwrt.org> <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com> <51152D9E.1040106@openwrt.org> <20130227192030.GW12537@pogo>
 <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com> <512ECE01.8010102@openwrt.org> <20782.54505.239733.82364@gargle.gargle.HOWL> <512EDDC5.7020901@openwrt.org> <20784.48093.263373.125536@gargle.gargle.HOWL>
 <CAJ-Vmon8B=wUkSd5tq=e-2FoUZykv28TD+tR71+-1R0W9_hYew@mail.gmail.com> <20785.24998.602035.570736@gargle.gargle.HOWL> <CAJ-Vmokn4A7nQdOHa4iJU=mP6_VEfHn8nYB1fsDiUhbZ1Z2mwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-1358737602-1362212794=:20413"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-1358737602-1362212794=:20413
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-03-01 21:40 -0800, Adrian Chadd wrote Sujith Manoharan:

AC>On 1 March 2013 18:19, Sujith Manoharan <sujith@msujith.org> wrote:
AC>> Adrian Chadd wrote:
AC>>> (190mbit TCP on 2-stream? Damn. Looks like I have a little more
AC>>> optimisation to do in FreeBSD. I'm only hitting 160/170mbit TCP on
AC>>> AR9280<->AR9280 and AR9280<->AR9287. But I hit 220-240mbit UDP.)
AC>>
AC>> I used a AR9462 card for this test. With AR9280/AR9287 I get abysmal
AC>> numbers with both rate control algorithms. Maybe something has regressed
AC>> in ath9k for the AR9002 family...
AC>
AC>It's almost like we need some kind of lab space set aside for running
AC>regression tests with all of the ath9k hardware ,dating back to
AC>AR5416, with some automated testing rigs..

Think this is good idea, have same problem - no mo ~50 megabit on ar9002.

AC>I have the hardware. Who wants to do it? :)


C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-1358737602-1362212794=:20413--
