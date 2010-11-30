Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab0K3KDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 05:03:44 -0500
Received: by bwz15 with SMTP id 15so4839159bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 02:03:43 -0800 (PST)
Message-ID: <4CF4CBFC.9090401@googlemail.com>
Date: Tue, 30 Nov 2010 11:03:40 +0100
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: linux newbie <linux.newbie79@gmail.com>
CC: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: Re: Hostapd + wpa_supplicant
References: <AANLkTinS5M3YBj4f97F2+hiDTaxRbs-RM7D8q=M_T4qW@mail.gmail.com>	<AANLkTi=6x1xXHmm3XyoqiV_NV6-+r8rXVMOBATULm4KO@mail.gmail.com>	<4CF4B7F3.7060601@googlemail.com> <AANLkTikWc8=A4ofV4ANHXndyC_sHUh0x-LH8_t=+rC7M@mail.gmail.com>
In-Reply-To: <AANLkTikWc8=A4ofV4ANHXndyC_sHUh0x-LH8_t=+rC7M@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi linux newbie!

You want a wireless mesh:

http://en.wikipedia.org/wiki/802.11s
http://en.wikipedia.org/wiki/Wireless_mesh_network

I just found those two articles, but searching the Internet for
"802.11s" or "wireless mesh" or whatever will give you an enormous
amount of information about meshing.

Kind regards,
Dennis Borgmann

linux newbie schrieb:
> Hi Dennis,
>
> Thanks for your reply.
>
> * My embedded device (wireless terminal) has only one network interface.
>
> I am currently trying to do following setup.
>
> * We have wireless terminals communicating to AP.
> * There are situations in which some terminals goes out of coverage.
> * We like to enable AP (in repeater or bridge mode) in our terminals,
> so that out-of-coverage terminals can communicate with other terminals
> which has coverage.
> * So that we can maintain the coverage all the time.
>
> Please let me know, if this is possible to achieve.
>
> Thanks
>
> On Tue, Nov 30, 2010 at 7:38 PM, Dennis Borgmann
> <dennis.borgmann@googlemail.com> wrote:
>   
>> Hello linux newbie!
>>
>> It is not quite clear from your message, what you would like to do. Are
>> you running only one wireless device within your embedded target? If so,
>> it is not possible to run hostapd and wpa_supplicant at the same time,
>> since the wireless card can only work in either AP or station mode. Both
>> at the same time is not possible. So what you would need to do is write
>> scripts, that kill the station mode, create an AP mode or the other way
>> around depending on what you need at a defined point of time.
>>
>> If you want to run hostapd and wpa_supplicant at the very same time, for
>> your embedded target to be an AP and a station at the very same moment,
>> you will need to run two wireless interfaces on your target.
>>
>> HTH,
>> Dennis Borgmann
>>
>> linux newbie schrieb:
>>     
>>> Hi,
>>>
>>> Any suggestion?
>>>
>>> Thanks
>>>
>>> On Mon, Nov 29, 2010 at 3:13 PM, linux newbie <linux.newbie79@gmail.com> wrote:
>>>
>>>       
>>>> Hi,
>>>>
>>>> * On my embedded target, I am running rt73 based usb wireless adapter.
>>>> * tested hostapd and wpa_supplicant individually and it is working fine.
>>>> * bothe hostapd and wpa_supplicant are latest 0.7.3 versions with
>>>> libnl_1.1 version & kernel 2.6.35
>>>>
>>>> If I run both wpa_supplicant and hostapd I am having issue.
>>>>
>>>> Reason for running hostapd and wpa_supplicant on same terminal is we
>>>> have multiple wireless terminals and if one of them can't access the
>>>> AP (due to coverage issue) , then it will bind to Hostapd on some
>>>> other terminal. I am not sure, if I can able to configure my terminals
>>>> to use both hostapd & wpa_supplicant and need your expert advice.
>>>>
>>>> Thanks
>>>>
>>>>
>>>>         
>>> _______________________________________________
>>> HostAP mailing list
>>> HostAP@lists.shmoo.com
>>> http://lists.shmoo.com/mailman/listinfo/hostap
>>>
>>>       
>>     

