Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serv04.lahn.de ([213.239.197.57]:57942 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891Ab2GMJdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 05:33:09 -0400
Received: from xenia.leun.net (localhost [127.0.0.1])
	by xenia.leun.net (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id q6D9O68o022107
	for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 11:24:07 +0200
Date: Fri, 13 Jul 2012 11:24:06 +0200
From: Michael Leun <lkml20120218@newton.leun.net>
To: <linux-wireless@vger.kernel.org>
Subject: ath9k_htc: Issue with channel 52 and above (DFS?)
Message-ID: <20120713112406.29aca09a@xenia.leun.net> (sfid-20120713_113312_856201_C0CED11B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

with an intel based and an ath9k mini pci express card I see my 5GHz AP
in iwlist scan results regardless if it is on channels 36-48 or on 52
and above.

With this

Bus 002 Device 031: ID 0846:9018 NetGear, Inc. WNDA3200 802.11abgn Wireless Adapter [Atheros AR7010+AR9280]

ath9k_htc based card I see the same AP only if it operates on channel
36-48, I do NOT see it in iwlist scan results if it is on channel 52 to
140 - I again see it when it is on 149 or above.

So, exactly the channels which require radar detection seem to be
missing.

I wonder why this happens (if related to DFS) - radar detection needs
to happen on the AP, not the client, or do I overlook something?


-- 
MfG,

Michael Leun

