Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [119.255.1.60] ([119.255.1.60]:52988 "EHLO
	mail.watchdata.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1L3IQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 03:16:56 -0500
Received: from localhost (mail.watchdata.com.cn [127.0.0.1])
	by mail.watchdata.com.cn (Postfix) with SMTP id AAE2120069
	for <linux-wireless@vger.kernel.org>; Fri, 30 Dec 2011 16:05:56 +0800 (CST)
From: =?gb2312?B?wO641Q==?= <gang.li@watchdata.com>
To: <linux-wireless@vger.kernel.org>
Cc: "'Ath9k Devel List'" <ath9k-devel@lists.ath9k.org>
Subject: Question: ieee80211_rx called twice after one ieee80211_subif_start_xmit call
Date: Fri, 30 Dec 2011 16:15:05 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
In-Reply-To: <CADGLRPmkbTp-azGJ2=CJum=Y8Mrf7fTbaE9Oi8Om+DQyu7d9uA@mail.gmail.com>
Message-Id: <20111230080554.DE64420052@mail.watchdata.com.cn> (sfid-20111230_091659_943492_2FFB5092)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi sirs,

	Today, I noticed that when an data frame is sent by
ieee80211_subif_start_xmit, then ieee80211_rx will be called twice , first
is an Acknowledgement frame and second is the response data frame.  Is this
the normal case?   It seems the RA frame is nonsense and just be freed in
ieee80211_rx_monitor.

	Is there anyway to tell the hardware not report RA frame to
mac80211?


Thanks very much!

Li gang



