Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:41323 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZH2BG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 21:06:26 -0400
Received: from [76.91.220.157] (helo=[192.168.1.28])
	by lirone.symas.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <hyc@symas.com>)
	id 1MhCOi-0000Js-H8
	for linux-wireless@vger.kernel.org; Fri, 28 Aug 2009 18:06:28 -0700
Message-ID: <4A987F0F.9040905@symas.com>
Date: Fri, 28 Aug 2009 18:06:23 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k DMA problems
References: <4A958F45.40109@symas.com>
In-Reply-To: <4A958F45.40109@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am I the only one having these problems? ath9k hasn't worked well for me since 
2.6.29.4; every snapshot since then has suffered from random drops. In 
2.6.29.6 it at least would quickly reassociate. The current ones hang within 
20-30 minutes of use and never come back. The compat-wireless snapshots have 
all been equally unusable.

Howard Chu wrote:
> Still seeing occasional hangs using the ath9k in 2.6.31-rc6, and even worse
> using compat-wireless 2009-08-22. Today I got this which was even more
> interesting:
>
> [369014.776586] wlan0: associate with AP 00:12:17:26:56:10 (try 1)
> [369014.779197] wlan0: RX ReassocResp from 00:12:17:26:56:10 (capab=0x411
> status=0 aid=2)
> [369014.779197] wlan0: associated
> [369472.707961] ath9k: DMA failed to stop in 10 ms AR_CR=0xdeadbeef
> AR_DIAG_SW=0xdeadbeef
>
> This is on an HP dv5z laptop, it reports an AR9280 at boot.


-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
