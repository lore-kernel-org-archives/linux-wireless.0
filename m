Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:33300 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbCZQ4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 12:56:14 -0400
Received: by qgfa8 with SMTP id a8so100434051qgf.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 09:56:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5514377C.1070906@lwfinger.net>
References: <CABU1Ay8sVdLuHURHhmhsOf_aCVgvYnR_fw6_HyqLXziGmp3_fA@mail.gmail.com>
	<5514377C.1070906@lwfinger.net>
Date: Thu, 26 Mar 2015 18:56:13 +0200
Message-ID: <CABU1Ay_FfqDsRB1m0ysS+gEc=R-CuNsYbLr+cC11me5CnAsT=Q@mail.gmail.com> (sfid-20150326_175618_010940_3456EFCE)
Subject: Re: mediatek mt7630e and ksoftirqd CPU load
From: George Moutsopoulos <gmoutso@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Larry for the prompt reply. This is very clear.
Regards,
George

On Thu, Mar 26, 2015 at 6:44 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 03/26/2015 11:12 AM, George Moutsopoulos wrote:
>>
>> Dear developers,
>>
>> if this is not the right place to post this, sorry for the spam. I
>> haven't filed a bug report yet. Tell me if I should. I am not sure if
>> the problem is something kernel developers can solve.
>>
>> On a laptop ASUS TP500LN, I have a wireless pcie card mt7630e from
>> mediatek. It is a wifi/bluetooth combo.
>>
>> The driver is not in the kernel, but mediatek provides it for linux
>> from the download site
>> http://www.mediatek.com/en/downloads/
>>
>> The driver does not support kernel 3.16 and above. I followed the
>> instructions at
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1220146
>>
>> The module compiles and loads succesfully. I followed the post by
>> tobias bora from the ubuntu bug. It compiles on kernel version 3.16
>> and above (tried up to 3.19).
>>
>> Like the rest on the ubuntu bug list, the wifi works and I connect
>> succesfully, but ksoftirqd gets 100% cpu on one of the cores.
>>
>> Shall I open a bug report? I have contacted mediatek twice but they
>> haven't replied. I hope it is something you can look at.
>
>
> Due to the fact that the driver is not in the kernel, it is not possible to
> file a bug with anyone but the vendor.
>
> It is possible that someone on this list with Mediatek experience may be
> able to help you, but there is no certainty. That is the downside of using a
> vendor driver.
>
> As the specs for that computer specify "integrated 802.11 b/g/n", it is
> probably not possible to change that device. I suggest that you purchase an
> inexpensive USB wifi stick to provide wifi on this computer. If you do so,
> you will be aware enough to check for Linux compatibility.
>
> Larry
>
