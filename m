Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47136 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208AbbAYTiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:38:46 -0500
Received: by mail-wi0-f176.google.com with SMTP id em10so6174960wid.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 11:38:45 -0800 (PST)
Message-ID: <54C54642.7000108@gmail.com> (sfid-20150125_203851_102729_C6B163E1)
Date: Sun, 25 Jan 2015 20:38:42 +0100
From: =?UTF-8?B?RnJhbsOnb2lzIFZhbGVuZHVj?= <francoisvalenduc@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Kernel crash while copying big files since kernel 3.18
References: <54AA3953.20603@gmail.com> <54AAC925.6050602@lwfinger.net> <54AADC22.9050105@gmail.com> <54AAE532.6050104@lwfinger.net> <54B28A3F.3000904@gmail.com> <54B2AC1B.8030107@lwfinger.net>
In-Reply-To: <54B2AC1B.8030107@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 11/01/15 18:00, Larry Finger a écrit :
> On 01/11/2015 08:35 AM, François Valenduc wrote:
>> Do you still intend to remove the line about allocation failure in the
>> log ? I made a backup of my root partition compressed with pixz and that
>> line appeared 1350 times. So I removed the code which add this line. Is
>> it really expected that it occurs so often ? pixz use multithreading to
>> compress files and therefore at least 3 of the 4 CPU are used during
>> around 20 minutes, but are you sure there is no other problems ?
>
> Yes, I do intend to remove that line; however, I want to keep it for a
> while just in case there are other crashes. If this message never
> appears in that case, then there is another bug.
>
> You are, of course, free to remove it from your system. BTW, how much
> memory do you have?
>
> Larry
>
>
Sorry for having forgotten to answer. I have 4 Gb of RAM. Taking a
backup of a DVD with k9copy also produces so much messages (1479 with a
patch using rate_limit).
Is it really expected that skb allocation fails so often ? Could there
be another problem ?

François
