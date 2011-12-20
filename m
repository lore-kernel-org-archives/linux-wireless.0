Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [119.255.1.60] ([119.255.1.60]:34536 "EHLO
	mail.watchdata.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1LTFko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 00:40:44 -0500
Received: from localhost (mail.watchdata.com.cn [127.0.0.1])
	by mail.watchdata.com.cn (Postfix) with SMTP id 2350520071
	for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 13:29:51 +0800 (CST)
From: =?gb2312?B?wO641Q==?= <gang.li@watchdata.com>
To: "'Sujith'" <m.sujith@gmail.com>
Cc: "'wireless'" <linux-wireless@vger.kernel.org>
Subject: RE: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
Date: Tue, 20 Dec 2011 13:39:41 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
In-Reply-To: <20207.19812.522615.450498@gargle.gargle.HOWL>
Message-Id: <20111220052951.0C13C20012@mail.watchdata.com.cn> (sfid-20111220_064048_109574_D2C20484)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Hi everybody!
> >
> > My wireless card is AR9280. I set the IEEE80211_TX_CTL_NO_ACK flag
before
> > send a packet, but found it no use. It still wait for an ACK. Then I
read
> > the code,
> > in ath9k_htc_tx_data(htc_drv_txrx.c) , it seems there is only two flags:
> >
> > #define ATH9K_HTC_TX_CTSONLY      0x1
> > #define ATH9K_HTC_TX_RTSCTS       0x2
> >
> > None is about ack.
> >
> > Does anyone know how to make this flag work properly?
> >
> 
> NOACK usage is not handled by ath9k_htc.
> See: http://linuxwireless.org/en/users/Drivers/ath9k_htc#TODO
> 

Thanks£¡

So , is there any way to set the re-transmit times when ACK not received?
Now , it will send 10 times.

> Sujith
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

