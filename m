Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [119.255.1.60] ([119.255.1.60]:47844 "EHLO
	mail.watchdata.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1LSMKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 07:10:30 -0500
Received: from localhost (mail.watchdata.com.cn [127.0.0.1])
	by mail.watchdata.com.cn (Postfix) with SMTP id D626A20069
	for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 19:28:45 +0800 (CST)
Received: from ligang (unknown [10.0.112.56])
	by mail.watchdata.com.cn (Postfix) with ESMTP id C748820066
	for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 19:28:45 +0800 (CST)
From: =?gb2312?B?wO641Q==?= <gang.li@watchdata.com>
To: "'wireless'" <linux-wireless@vger.kernel.org>
Subject: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
Date: Mon, 19 Dec 2011 19:38:23 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
In-Reply-To: <4EED232D.3010208@lwfinger.net>
Message-Id: <20111219112845.C748820066@mail.watchdata.com.cn> (sfid-20111219_131033_890271_4109FA40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everybody!

My wireless card is AR9280. I set the IEEE80211_TX_CTL_NO_ACK flag before
send a packet, but found it no use. It still wait for an ACK. Then I read
the code,
in ath9k_htc_tx_data(htc_drv_txrx.c) , it seems there is only two flags:

#define ATH9K_HTC_TX_CTSONLY      0x1
#define ATH9K_HTC_TX_RTSCTS       0x2

None is about ack.

Does anyone know how to make this flag work properly?

Thanks a lot!

gang.li




