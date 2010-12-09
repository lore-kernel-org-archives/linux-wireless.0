Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f172.google.com ([209.85.214.172]:57140 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab0LIFqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 00:46:34 -0500
Received: by iwn40 with SMTP id 40so2860505iwn.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 21:46:34 -0800 (PST)
Message-ID: <4D006D31.4000604@gmail.com>
Date: Thu, 09 Dec 2010 16:46:25 +1100
From: Wade Fitzpatrick <wade.fitzpatrick@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: carl9170 connect/disconnect loop
References: <AANLkTingL2eooC2+jH6nQVADKZBFemE=6eTQ_Vhx_Swx@mail.gmail.com> <201012070032.23135.chunkeey@googlemail.com>
In-Reply-To: <201012070032.23135.chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 07/12/10 10:32, Christian Lamparter wrote:
> mac80211 comes with some powerful debug tools.
> Since you get the disconnects fairly quickly, you should
> setup a wlan monitor.
>
> <http://linuxwireless.org/en/users/Documentation/iw#Adding_interfaces_with_iw>
>   iw dev wlan1 interface add mon type monitor flags otherbss control
>   ifconfig mon up
>
I'm getting a kernel panic just after bringing up the interface with 
ifconfig. It mentions this info:

skb_under_panic ...
kernel BUG at net/core/skbuff.c:146!
Call Trace:
<IRQ>
   skb_defer_rx_timestamp
   netif_receive_skb


$ uname -vmpir
2.6.36-ARCH #1 SMP PREEMPT Wed Nov 24 00:39:57 CET 2010 x86_64 AMD 
Phenom(tm) II X4 955 Processor AuthenticAMD

