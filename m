Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58480 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZINOTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 10:19:44 -0400
Received: by bwz19 with SMTP id 19so2108200bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 07:19:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAE3DF7.7060504@lwfinger.net>
References: <3b0e19890909122130l6c447e40r977f050e1a099794@mail.gmail.com>
	 <4AAE3DF7.7060504@lwfinger.net>
Date: Mon, 14 Sep 2009 09:19:46 -0500
Message-ID: <3b0e19890909140719y7971c9f4m5fe086a9008fd423@mail.gmail.com>
Subject: Re: RTL8187B wireless driver issue
From: Vignette consultant <vignette75@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi

 I just built linux kernel 2.6.31 on ubuntu 9.0.4 2.6.28-11 server.
The dhcpclient wlan0 still is unable to get ip address.

 I don't see any message in dmesg log for wlan0. The laptop uses
RTL8187 built-in usb card.

 The Vista is able to connect through wireless dhcp without any
problem. The linux is not.

 How can I trace the root cause of this issue.

 Thanks
 Sam

On 9/14/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Vignette consultant wrote:
>>  Larry,
>>
>>  I am using Ubuntu 9.0.4 server edition with kernel image 2.6.30.05
>> using rtl8187.ko driver module for RTL8187 wireless adapter.
>>
>>  It always reports "wlan0 link not ready" error causing not able to
>> use wireless connection at all while trying to get dhcp ip lease. I
>> also get the same "eth0 link not ready" error.
>>
>>  Can you advise of any solution?
>>
>>  PS - I get the same error with Ubuntu 2.6.28-11 server kernel image
>> also. I even reinstall it, but no luck so far. It gives me same error
>> even if I turn off wireless radio!
>
> Please post any messages to the wireless list. That way the general
> community can learn and participate, particularly when I get it wrong.
>
> The usual reason for the "link not ready" message is that the network
> is down. How are you controlling the network? For wireless, that
> message can come from the rfkill switch being off; however, that
> functionality is not implemented in 2.6.30 for rtl8187.
>
> Larry
>
>
>
