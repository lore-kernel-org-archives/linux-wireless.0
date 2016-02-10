Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34791 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbcBJBMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 20:12:01 -0500
Received: by mail-ob0-f175.google.com with SMTP id wb13so7155895obb.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2016 17:12:00 -0800 (PST)
Subject: Re: alfa awus036nhr v2 and module rtl8xxxu
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <loom.20160128T003525-188@post.gmane.org>
 <wrfjd1sco25f.fsf@redhat.com> <56B38CDF.9010806@lwfinger.net>
 <wrfjd1scmkz6.fsf@redhat.com> <wrfj60xxd2f5.fsf@redhat.com>
Cc: Drunk Cat <natserver2@gmail.com>, linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56BA8E5D.5090402@lwfinger.net> (sfid-20160210_021206_402539_A1F824EB)
Date: Tue, 9 Feb 2016 19:11:57 -0600
MIME-Version: 1.0
In-Reply-To: <wrfj60xxd2f5.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2016 03:00 PM, Jes Sorensen wrote:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>> On 02/04/2016 10:45 AM, Jes Sorensen wrote:
>>>> Drunk Cat <natserver2@gmail.com> writes:
>>>>> problem: it does not connect to any wifi network you can see the time out on
>>>>> dmesg
>>>>>
>>>>>
>>>>>> lsusb
>>>>>
>>>>> Bus 002 Device 007: ID 0bda:817f Realtek Semiconductor Corp. RTL8188RU
>>>>> 802.11n WLAN Adapter
>>>>>
>>>>>> iwconfig
>>>>> wlp0s20u1  IEEE 802.11bgn  ESSID:off/any
>>>>>             Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>>>>>             Retry short limit:7   RTS thr=2347 B   Fragment thr:off
>>>>>             Power Management:off
>>>>>> dmesg
>>>>
>>>> Not sure what distribution you are running, but I am seeing problems
>>>> with NetworkManager in recent Fedora.
>>>>
>>>> Could you try the following:
>>>> 1) Unplug the WiFi dongle
>>>> 2) (Re)load the driver (rmmod rtl8xxxu ; insmod rtl8xxxu)
>>>> 3) Restart NetworkManager 'systemctl restart NetworkManager'
>>>> 4) Plug in the WiFi dongle
>>>
>>> Jes,
>>>
>>> I can confirm what Drunk Cat sees. There is something different about
>>> the RTL8192RU as using the iwconfig utility shows no APs in the
>>> scan. I hope to get to debugging the problem soon.
>>
>> OK - thats unfortunate. Most likely the wrong antenna path is being
>> enabled for it, or something like that.
>>
>> Once I finish up the 8723bu/8192eu patchset, I'll try to find some time
>> to look at it, if you don't nail it before.
>
> One more time with the actual patch ...

No help. The name of the patch makes it sound as if it is for a 1T2R device. The 
RTL8188RU is 1x1.

Larry


