Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:39293 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757194Ab0GNSLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 14:11:12 -0400
Message-ID: <4C3DFDB5.10904@redfish-solutions.com>
Date: Wed, 14 Jul 2010 12:11:01 -0600
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH] compat-wireless: fix build of ath5k for CONFIG_PM_SLEEP=n
References: <1278879791-12646-1-git-send-email-hauke@hauke-m.de> 	<AANLkTimLweydYTbS-O6Q2sX-W0H5z7cWOLUqQphSTO1s@mail.gmail.com> 	<4C3B6AAE.4070204@redfish-solutions.com> <AANLkTilfUKMido8N4vRF4Em7ewtoUAlkrsp1uaKTx6H9@mail.gmail.com> <AANLkTilVf_eOMqvYwcz5XrSVFuk3RNLl7SoVOj-6L6Fu@mail.gmail.com>
In-Reply-To: <AANLkTilVf_eOMqvYwcz5XrSVFuk3RNLl7SoVOj-6L6Fu@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2010 04:44 PM, Luis R. Rodriguez wrote:
> On Tue, Jul 13, 2010 at 2:54 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Mon, Jul 12, 2010 at 12:19 PM, Philip A. Prindeville
>> <philipp_subx@redfish-solutions.com> wrote:
>>> On 07/12/2010 09:30 AM, Luis R. Rodriguez wrote:
>>>> On Sun, Jul 11, 2010 at 1:23 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>>>> suspend and resume are activated in ath5k if CONFIG_PM_SLEEP is set and
>>>>> not if just CONFIG_PM is set.
>>>>>
>>>>> This should fix the problems reported by Philip Prindeville.
>>>>>
>>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>>
>>>> Thanks! Applied and pushed out, at noon we'll have a new tarball with this.
>>>>
>>>>   Luis
>>>
>>> And...
>>>
>>>
>>>  CC [M]  /home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth/l2cap.o
>>> /home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth/l2cap.c: In function 'l2cap_data_channel':
>>> /home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth/l2cap.c:4352: error: void value not ignored as it ought to be
>>> make[4]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth/l2cap.o] Error 1
>>> make[3]: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/bluetooth] Error 2
>>> make[2]: *** [_module_/home/philipp/kernel/build_i586/compat-wireless-2010-07-12] Error 2
>>> make[2]: Leaving directory `/home/philipp/kernel/build_i586/linux-2.6.27.48-astlinux'
>>> make[1]: *** [modules] Error 2
>>> make[1]: Leaving directory `/home/philipp/kernel/build_i586/compat-wireless-2010-07-12'
>>> make: *** [/home/philipp/kernel/build_i586/compat-wireless-2010-07-12/net/wireless/lib80211.ko] Error 2
>>
>> Thanks for reporting this, I am working on it now.
> 
> This is now fixed, I'll push out a new tarball shortly.
> 
>   Luis

That tarball never made it out...  can you please retry?

Thanks.


