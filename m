Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:38773 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZHZTjL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 15:39:11 -0400
Received: from [76.91.220.157] (helo=[192.168.1.28])
	by lirone.symas.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <hyc@symas.com>)
	id 1MgOKv-0007IL-Jf
	for linux-wireless@vger.kernel.org; Wed, 26 Aug 2009 12:39:13 -0700
Message-ID: <4A958F45.40109@symas.com>
Date: Wed, 26 Aug 2009 12:38:45 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k DMA problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Still seeing occasional hangs using the ath9k in 2.6.31-rc6, and even worse 
using compat-wireless 2009-08-22. Today I got this which was even more 
interesting:

[369014.776586] wlan0: associate with AP 00:12:17:26:56:10 (try 1)
[369014.779197] wlan0: RX ReassocResp from 00:12:17:26:56:10 (capab=0x411 
status=0 aid=2)
[369014.779197] wlan0: associated
[369472.707961] ath9k: DMA failed to stop in 10 ms AR_CR=0xdeadbeef 
AR_DIAG_SW=0xdeadbeef

This is on an HP dv5z laptop, it reports an AR9280 at boot.
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
