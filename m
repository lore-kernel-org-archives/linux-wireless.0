Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55813 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2AHQSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 11:18:51 -0500
Received: by iaeh11 with SMTP id h11so5474156iae.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 08:18:50 -0800 (PST)
Message-ID: <4F09C1E2.6020907@gmail.com> (sfid-20120108_171854_171888_FD5FF237)
Date: Mon, 09 Jan 2012 00:18:42 +0800
From: lina <lina.lastname@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: modprob b43 not work after hilibernate
References: <4F09AAE5.2080209@gmail.com> <4F09BEC0.7080702@lwfinger.net>
In-Reply-To: <4F09BEC0.7080702@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09,January,2012 12:05 AM, Larry Finger wrote:
> On 01/08/2012 08:40 AM, lina wrote:
>> Hi,
>>
>> after hibernation,
>>
>> I tried modprob b43 and /etc/initi.d/network-manager restart not work,
>>
>> is it reboot the only option. ( I googled it seems, not so sure)
>
> Hibernation involves so many parts of the computer that it is hard to
> tell what is happening. If unloading and reloading b43 using modprobe
> does not help, then it is not solely a problem with b43.
>
> You need to provide a better description of what you are doing. Include
> specific output from dmesg and the exact commands you are trying. You
> should also include what distro you are running, your kernel version,
> and what brand and model of computer you are using.

It's fine with me to reboot.

3.2.0-1 SMP  x86_64 GNU/Linux

Debian wheezy.

I upload the dmesg output in the following link,

https://docs.google.com/open?id=0B93SVRfpVVg3ZThiYmQ3NjctOWU2Ni00ODQ5LTgzMGMtMGMyMDgxMjVjYTFl

It's absolutely not something urgent or very-necessary to me, so just 
take your time and interest, I was just asking. btw, if there is some 
problem in the dmesg, maybe not high relevant to this topic, please also 
feel free to let me know.
any further info you need just let me know,

Thanks,
>
> Larry
>

