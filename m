Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36143 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbcDZJ5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:57:42 -0400
Received: by mail-io0-f195.google.com with SMTP id k129so1413355iof.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 02:57:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r3dswxom.fsf@purkki.adurom.net>
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
	<87r3dswxom.fsf@purkki.adurom.net>
Date: Tue, 26 Apr 2016 10:57:41 +0100
Message-ID: <CAL3+40HdyydJ=HrKSqTT2jOv7t9K8vfo4s_b8oJwWFAT9wQHEw@mail.gmail.com> (sfid-20160426_115745_803054_4EE6D6AF)
Subject: Re: Intel 7260 AC only using 802.11n not AC
From: Radu P <rrrpan@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get no output when running:

iw dev wlan1 scan|grep VHT

Switched to firmware 16 and same result.

On Tue, Apr 26, 2016 at 10:01 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Radu P <rrrpan@gmail.com> writes:
>
>> These is the relevant data:
>>
>> firmware-version: 17.265642.0
>>
>> [  292.689871] iwlwifi 0000:04:00.0: loaded firmware version
>> 17.265642.0 op_mode iwlmvm
>> [  292.702902] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
>> Wireless AC 7260, REV=0x144
>>
>> wlan1     IEEE 802.11abgn <- not AC
>>
>> Kernel version: 4.4.0-21-generic #37~14.04.1-Ubuntu
>>
>> AC mode is working with Windows 10.
>
> Don't use iwconfig, it's ancient and deprecated. Use iw instead.
>
> --
> Kalle Valo
