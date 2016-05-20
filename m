Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36140 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbcETSSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 14:18:11 -0400
Received: by mail-wm0-f66.google.com with SMTP id q62so3126521wmg.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2016 11:18:10 -0700 (PDT)
Subject: Re: updating carl9170-1.fw in linux-firmware.git
To: Ben Hutchings <ben@decadent.org.uk>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <20160416113312.8de2266358165182bb4b4a15@gmx.com>
 <11418613.XH7h8m2RjK@debian64> <87a8koiubz.fsf@kamboji.qca.qualcomm.com>
 <2185358.G319l0XIJC@debian64>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Linux Firmware Maintainers <linux-firmware@kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <a2bcbbc3-e68d-72a7-ae11-29bb74fc1266@gmail.com> (sfid-20160520_201815_536329_809C2E06)
Date: Fri, 20 May 2016 20:18:07 +0200
MIME-Version: 1.0
In-Reply-To: <2185358.G319l0XIJC@debian64>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2016 11:11 PM, Christian Lamparter wrote:

> On Wednesday, April 20, 2016 10:59:44 AM Kalle Valo wrote:
>> Christian Lamparter <chunkeey@googlemail.com> writes:
>>
>>> On Monday, April 18, 2016 07:42:05 PM Kalle Valo wrote:
>>>> Christian Lamparter <chunkeey@googlemail.com> writes:
>>>>
>>>>> On Monday, April 18, 2016 06:45:09 PM Kalle Valo wrote:
>>>>>
>>>>>> Why even mention anything about a "special firmware" as the firmware is
>>>>>> already available from linux-firmware.git? 
>>>>>
>>>>> Yes and no. 1.9.6 is in linux-firmware.git. I've tried to add 1.9.9 too
>>>>> but that failed.
>>>>> <http://comments.gmane.org/gmane.linux.kernel.wireless.general/114639>
>>>>
>>>> Rick's comment makes sense to me, better just to provide the latest
>>>> version. No need to unnecessary confuse the users. And if someone really
>>>> wants to use an older version that she can retrieve it from the git
>>>> history.
>>>
>>> Part of the fun here is that firmware is GPLv2. The linux-firmware.git has
>>> to point to or add the firmware source to their tree. They have added every
>>> single source file to it.... instead of "packaging" it in a tar.bz2/gz/xz
>>> like you normally do for release sources.
>>>
>>> If you want to read more about it:
>>> <http://www.spinics.net/lists/linux-wireless/msg101868.html>
>>
>> Yeah, that's more work. I get that. But I'm still not understanding
>> what's the actual problem which prevents us from updating carl9170
>> firmware in linux-firmware.

> I'm not sure, but why not ask? I've added the cc'ed Linux Firmware
> Maintainers. So for those people reading the fw list:
> 
> What would it take to update the carl9170-1.fw firmware file in your
> repository to the latest version?
> 
> Who has to sent the firmware update. Does it have to be the person who
> sent the first request? (Xose)? The maintainer of the firmware (me)?
> someone from Qualcomm Atheros? Or someone else (specific)? (the 
> firmware is licensed as GPLv2 - in theory anyone should be able to
> do that)
> 
> How should the firmware source update be handled? Currently the latest
> .tar.xz of the firmware has ~130kb. The formated patches from 1.9.6 to
> latest are about ~100kb (182 individual patches).
> 
> How does linux-firmware handle new binary firmware images and new 
> sources? What if carl9170fw-2.bin is added. Do we need another
> source directory for this in the current tree then? Because 
> carl9170fw-1.bin will still be needed for backwards compatibility
> so we basically need to duplicate parts of the source?
> 
> Also, how's the situation with ath9k_htc? The 1.4.0 image contains
> some GPLv2 code as well? So, why is there no source in the tree, but 
> just the link to it? Because, I would like to do basically the same
> for carl9170fw and just add a link to the carl9170fw repository and
> save everyone this source update "song and dance".

Hi Ben, could you assist Christian ?

-thanks-
