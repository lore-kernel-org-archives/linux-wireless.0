Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34512 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1LSOm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 09:42:59 -0500
Received: by ghbz12 with SMTP id z12so3502466ghb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 06:42:58 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <20207.19812.522615.450498@gargle.gargle.HOWL> (sfid-20111219_154303_147159_2DE4FA2D)
Date: Mon, 19 Dec 2011 20:12:44 +0530
To: =?utf-8?Q?=E6=9D=8E=E5=88=9A?= <gang.li@watchdata.com>
Cc: "'wireless'" <linux-wireless@vger.kernel.org>
Subject: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
In-Reply-To: <20111219112845.C748820066@mail.watchdata.com.cn>
References: <4EED232D.3010208@lwfinger.net>
	<20111219112845.C748820066@mail.watchdata.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

李刚 wrote:
> Hi everybody!
> 
> My wireless card is AR9280. I set the IEEE80211_TX_CTL_NO_ACK flag before
> send a packet, but found it no use. It still wait for an ACK. Then I read
> the code,
> in ath9k_htc_tx_data(htc_drv_txrx.c) , it seems there is only two flags:
> 
> #define ATH9K_HTC_TX_CTSONLY      0x1
> #define ATH9K_HTC_TX_RTSCTS       0x2
> 
> None is about ack.
> 
> Does anyone know how to make this flag work properly?
> 

NOACK usage is not handled by ath9k_htc.
See: http://linuxwireless.org/en/users/Drivers/ath9k_htc#TODO

Sujith
