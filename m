Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:21157 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIJFCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 01:02:01 -0400
Message-ID: <540FDB3C.6060301@hartkopp.net> (sfid-20140910_070211_284184_31F7C24A)
Date: Wed, 10 Sep 2014 07:01:48 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: Vadim Kochan <vadim4j@gmail.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: iwlwifi no authentication with AP - Re: pull request: wireless-next
 2014-09-08
References: <20140908191630.GB29412@tuxdriver.com>	<540F5927.7000306@hartkopp.net>	<CANUX_P3n0v1SzfbYuaAsE4TY7Hz_wo2Fb9SmHVNyFOC9hDhwdg@mail.gmail.com>	<540F61D0.9000704@hartkopp.net> <CAMw6YJLeO1JZeY6hNe-TXOS56b-otk+htt5VPPor+9iYCQz53Q@mail.gmail.com>
In-Reply-To: <CAMw6YJLeO1JZeY6hNe-TXOS56b-otk+htt5VPPor+9iYCQz53Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10.09.2014 00:07, Vadim Kochan wrote:
> I have the same issue with iwlwifi.

I tried an old zd1211 wireless USB stick to check if this problem is 80211
related. But the USB stick works fine (I'm using it right now).
So its definitely looks like an iwlwifi issue.

> iwlwifi 0000:02:00.0: fail to flush all tx fifo queues Q 0

Wasn't there any change in the iwlwifi tx path recently??

Regards,
Oliver

> 
> On Tue, Sep 9, 2014 at 11:23 PM, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>> On 09.09.2014 22:02, Emmanuel Grumbach wrote:
>>> On Tue, Sep 9, 2014 at 10:46 PM, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>>>> Hello John, all,
>>>>
>>>> on my i7 Laptop with iwlwifi the latest net-next does not connect to my access point:
>>>
>>> Are you sure this wasn't the case before?
>>
>> Indeed I moved to net-next right today - as I also had the LED lockdep splat
>> on 3.17-rcX with X < 4.
>>
>> So it can be that this issue was already introduced at the beginning of this
>> net-next cycle. Don't know, sorry. The latest 3.17-rc4 from Linus' tree works
>> fine. I'm running a Debian unstable here (in both cases).
>>
>>> Can you bisect?
>>
>> Not really. I'm running the kernel on my bare machine - and I just wanted to
>> go to bed right now ...
>>
>> So I will be able to test patches tomorrow morning again.
>>
>> Tnx for your fast feedback,
>> Oliver
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
