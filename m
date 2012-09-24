Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28632 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2IXFP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 01:15:57 -0400
Message-ID: <505FEC86.7020201@qca.qualcomm.com> (sfid-20120924_071640_616282_AA79DB9B)
Date: Mon, 24 Sep 2012 10:45:50 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Ravi Sharma <sharmaravi.lx@gmail.com>
CC: Sunil Mehta <sunil2@telenetsystems.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <Mohammed@venema.h4ckr.net>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Felix Bitterli <felixb@qca.qualcomm.com>
Subject: Re: [ath9k-devel] :
References: <CC53EBAA.16239%sunil2@telenetsystems.com> <503318FD.7070108@qca.qualcomm.com> <CAEZZmbG78oO5_D3zncanXStYpuf_faoqq6rp3usPpd3_5+tBQA@mail.gmail.com>
In-Reply-To: <CAEZZmbG78oO5_D3zncanXStYpuf_faoqq6rp3usPpd3_5+tBQA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ravi,

I was on leave, will soon share the complete data that might help you..
p2p concurrency (having P2P go has some issues).

regards,
shafi

On Thursday 20 September 2012 04:07 PM, Ravi Sharma wrote:
> Hi,
>
> I am trying to setup concurrent mode for TL-WL722N (TP-LINK) (ath9k)
> and upgraded& used the driver with the latest compat release. I am
> trying to run STA & P2P concurrently with two supplicant. Is this
> configuration possible?
>
>
>
> I am using Ubuntu with kernel 3.2
>
> Can you please share the setup you are using to validate the ath9k
> mac80211 for concurrent mode?
>
> Regards,
> Ravi
>
> On Tue, Aug 21, 2012 at 10:43 AM, Mohammed Shafi Shajakhan
> <mohammed@qca.qualcomm.com> wrote:
>> Hi,
>>
>>
>> On Friday 17 August 2012 12:42 PM, Sunil Mehta wrote:
>>>>
>>>>
>>>> Hi
>>>
>>>
>>> We are using AR9331 and are currently using the device in - AP mode, and
>>> Station mode.
>>>
>>> We would like to use the device for a P2P application. Can you suggest
>>> what we need to do.
>>
>>
>> sorry for the delayed reply, i was on leave(did not check any mails!) for
>> the past 6 days.
>>
>> please read this and check this out, if it helps and works for you
>> http://linuxwireless.org/en/developers/p2p/howto.
>>
>> please let me know if there any basic configuration issues.
>>
>> technical issues related to p2p are discussed in hostap mailing lists
>> http://lists.shmoo.com/mailman/listinfo/hostap
>>
>>
>>
>>>
>>> Regards,
>>> Sunil.
>>>
>>>
>>
>>
>> --
>> thanks,
>> shafi
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
thanks,
shafi


