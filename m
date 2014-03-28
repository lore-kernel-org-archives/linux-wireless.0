Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48380 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaC1OjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 10:39:11 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so832300wiv.3
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 07:39:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <533584BF.70604@candelatech.com>
References: <5334F8E7.1070803@candelatech.com>
	<CA+icZUVe7Mwf2P=Jk3rHvqZEDf3otOP7DwM=y7_LVHd4t_koQA@mail.gmail.com>
	<533584BF.70604@candelatech.com>
Date: Fri, 28 Mar 2014 15:39:09 +0100
Message-ID: <CA+icZUUBH5zp4nVnP-B_tGUskn=Fsvcr5Ebo-QR7Joh8dYgmvQ@mail.gmail.com> (sfid-20140328_153915_770540_852E9B25)
Subject: Re: Setting txpower fails?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 28, 2014 at 3:18 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 03/28/2014 12:27 AM, Sedat Dilek wrote:
>>
>> On Fri, Mar 28, 2014 at 5:21 AM, Ben Greear <greearb@candelatech.com>
>> wrote:
>>>
>>> Any idea why this isn't working?
>>>
>>> Kernel is 3.9.11+, driver is ath9k.
>>>
>>> [root@ct523-9292 lanforge]# iwconfig wlan0
>>> wlan0     IEEE 802.11abgn  ESSID:off/any
>>>            Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
>>>            Retry short limit:7   RTS thr:off   Fragment thr:off
>>>            Encryption key:off
>>>            Power Management:off
>>>
>>> [root@ct523-9292 lanforge]# iwconfig wlan0 txpower 10
>>> [root@ct523-9292 lanforge]# echo $?
>>> 0
>>> [root@ct523-9292 lanforge]# iwconfig wlan0
>>> wlan0     IEEE 802.11abgn  ESSID:off/any
>>>            Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
>>>            Retry short limit:7   RTS thr:off   Fragment thr:off
>>>            Encryption key:off
>>>            Power Management:off
>>>
>>> [root@ct523-9292 lanforge]#
>>>
>>
>> Which version of wireless-tools?
>> Why don't you use modern iw?
>
>
> Do you know the right incantation for 'iw'?  From it's help, it seems
> this should work, but it throws an error.  I haven't dug into the
> code to figure out why...
>
> [root@ct523-9292 lanforge]# iw dev wlan0 set txpower 10
> Invalid parameter: 10
>

I have found [1] in the wiki.
For more details and a quick answer try to ask on IRC?

- Sedat -

[1] http://wireless.kernel.org/en/users/Documentation/iw#Setting_TX_power

> [root@ct523-9292 lanforge]# iwconfig --version
> iwconfig  Wireless-Tools version 29
>           Compatible with Wireless Extension v11 to v22.
>
> Kernel    Currently compiled with Wireless Extension v22.
>
> sta211    Recommend Wireless Extension v21 or later,
>           Currently compiled with Wireless Extension v22.
> ...
>
>
> Thanks,
> Ben
>
>>
>> - Sedat -
>>
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
