Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [119.255.1.60] ([119.255.1.60]:48284 "EHLO
	mail.watchdata.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759372Ab2AGCMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 21:12:33 -0500
Received: from localhost (mail.watchdata.com.cn [127.0.0.1])
	by mail.watchdata.com.cn (Postfix) with SMTP id CDA592005F
	for <linux-wireless@vger.kernel.org>; Sat,  7 Jan 2012 10:01:51 +0800 (CST)
From: =?gb2312?B?wO641Q==?= <gang.li@watchdata.com>
To: <linux-wireless@vger.kernel.org>,
	"'Ath9k Devel List'" <ath9k-devel@lists.ath9k.org>
Subject: Question about duration of data frame in ath9k_htc
Date: Sat, 7 Jan 2012 10:11:13 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
In-Reply-To: <CADGLRPmkbTp-azGJ2=CJum=Y8Mrf7fTbaE9Oi8Om+DQyu7d9uA@mail.gmail.com>
Message-Id: <20120107020151.B53C81FFF8@mail.watchdata.com.cn> (sfid-20120107_031237_478087_7CBC738D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Sirs,

	From wireshark, I noticed that when send an data frame , the
duration of frame control is fixed at 60 , no matter the frame length is 100
bytes or 1000 bytes.

	It seems this value is calculated in firmware and should be correct.
But I don't know why. And this value can be set in mac80211?


Thanks in advance!

Li gang



