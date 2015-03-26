Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33303 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbbCZQor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 12:44:47 -0400
Received: by obcxo2 with SMTP id xo2so1863968obc.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 09:44:47 -0700 (PDT)
Message-ID: <5514377C.1070906@lwfinger.net> (sfid-20150326_174450_778190_49D828C7)
Date: Thu, 26 Mar 2015 11:44:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: George Moutsopoulos <gmoutso@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mediatek mt7630e and ksoftirqd CPU load
References: <CABU1Ay8sVdLuHURHhmhsOf_aCVgvYnR_fw6_HyqLXziGmp3_fA@mail.gmail.com>
In-Reply-To: <CABU1Ay8sVdLuHURHhmhsOf_aCVgvYnR_fw6_HyqLXziGmp3_fA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2015 11:12 AM, George Moutsopoulos wrote:
> Dear developers,
>
> if this is not the right place to post this, sorry for the spam. I
> haven't filed a bug report yet. Tell me if I should. I am not sure if
> the problem is something kernel developers can solve.
>
> On a laptop ASUS TP500LN, I have a wireless pcie card mt7630e from
> mediatek. It is a wifi/bluetooth combo.
>
> The driver is not in the kernel, but mediatek provides it for linux
> from the download site
> http://www.mediatek.com/en/downloads/
>
> The driver does not support kernel 3.16 and above. I followed the
> instructions at
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1220146
>
> The module compiles and loads succesfully. I followed the post by
> tobias bora from the ubuntu bug. It compiles on kernel version 3.16
> and above (tried up to 3.19).
>
> Like the rest on the ubuntu bug list, the wifi works and I connect
> succesfully, but ksoftirqd gets 100% cpu on one of the cores.
>
> Shall I open a bug report? I have contacted mediatek twice but they
> haven't replied. I hope it is something you can look at.

Due to the fact that the driver is not in the kernel, it is not possible to file 
a bug with anyone but the vendor.

It is possible that someone on this list with Mediatek experience may be able to 
help you, but there is no certainty. That is the downside of using a vendor driver.

As the specs for that computer specify "integrated 802.11 b/g/n", it is probably 
not possible to change that device. I suggest that you purchase an inexpensive 
USB wifi stick to provide wifi on this computer. If you do so, you will be aware 
enough to check for Linux compatibility.

Larry

