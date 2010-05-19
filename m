Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.176.42]:38505 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0ESThm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 15:37:42 -0400
Received: from foot.mail.ru (foot.mail.ru [94.100.189.94])
	by fallback4.mail.ru (mPOP.Fallback_MX) with ESMTP id 0BF691DB150C
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 23:32:44 +0400 (MSD)
Received: from mail by foot.mail.ru with local
	id 1OEp09-0006Jt-00
	for linux-wireless@vger.kernel.org; Wed, 19 May 2010 23:32:21 +0400
From: Vladimir Preobrazhensky <vpreob@mail.ru>
To: linux-wireless@vger.kernel.org
Subject: ath5k breaks wifi link under load (AR5007EG)
Mime-Version: 1.0
Date: Wed, 19 May 2010 23:32:21 +0400
Reply-To: Vladimir Preobrazhensky <vpreob@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Message-Id: <E1OEp09-0006Jt-00.vpreob-mail-ru@foot.mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I got a kind of long-lasting problem, wish it has a solution.

I have an Atheros AR5007EG adapter in my netbook (acer aspire one AOA110) and wifi router is TrendNet TEW-452BRP. Kernel uses ath5k driver to control this.
PCI ID: vendor code VEN_168C, dev code DEV_001C.

I tried several linux kernels, starting from Ubuntu 8.04 (don't remember now which verision was there) to Ubuntu 10.4 and even have tried linux 2.6.34 today.

The wifi link seems to work in general, as long as I do some lazy web browsing, chatting, IM-ing etc, that is, which imposes low network utilization.
But every time I do something that causes a substantial network load, my wifi link breaks. I mean, that happens when I watch AVI files or download some other big files from my LAN samba server, or download some big RPM from the Internet.

The Windows XP system, pre-installed here, allows to watch video over wifi for hours.
The Ubuntu 10.4 Netbook Remix system performs well on video playback, when connected over wired thernet.


Regards,
Vladimir Probrazhensky

