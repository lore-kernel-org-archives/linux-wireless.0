Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33720 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3IMRXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 13:23:00 -0400
Received: by mail-oa0-f47.google.com with SMTP id g12so1446056oah.34
        for <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2013 10:22:59 -0700 (PDT)
Message-ID: <523349F2.2000702@lwfinger.net> (sfid-20130913_192304_101960_CFA53BD4)
Date: Fri, 13 Sep 2013 12:22:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Albert Lo <alo@airpatrolcorp.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: problems setting the channel
References: <bd4dc3b2edbb45789121bddb33960aa2@CO1PR05MB345.namprd05.prod.outlook.com>
In-Reply-To: <bd4dc3b2edbb45789121bddb33960aa2@CO1PR05MB345.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2013 12:11 PM, Albert Lo wrote:
>
> Hello,
>
> Forgive the newbie question, but I'm having a hard time setting the channel.  Here is my output:
>
> ======================================
> root@OpenWrt:~# iw dev wlan0 info
> Interface wlan0
>      ifindex 7
>      wdev 0x2
>      addr 04:f0:21:01:1b:91
>      type AP
>      wiphy 0
>      channel 11 (2462 MHz) NO HT
> root@OpenWrt:~# iw reg get
> country US:
>      (2402 - 2472 @ 40), (3, 27)
>      (5170 - 5250 @ 40), (3, 17)
>      (5250 - 5330 @ 40), (3, 20), DFS
>      (5490 - 5600 @ 40), (3, 20), DFS
>      (5650 - 5710 @ 40), (3, 20), DFS
>      (5735 - 5835 @ 40), (3, 30)
> root@OpenWrt:/# iw dev wlan0 set channel 10
> root@OpenWrt:/# iw dev wlan0 set channel 19
> command failed: Invalid argument (-22)

--snip--

> Any ideas as to how I can set wlan0 to the channels in  Band2?

There is no channel 19 in wifi! That is the reason you cannot select it.

To select Band 2, you would need a dual-band Access Point. Do you have one?

Clearly, you have little knowledge of wifi. I suggest you read 
http://en.wikipedia.org/wiki/List_of_WLAN_channels.

Larry

