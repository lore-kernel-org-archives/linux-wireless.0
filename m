Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:52171 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208Ab1CAGjU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 01:39:20 -0500
Received: by mail-iw0-f177.google.com with SMTP id 36so4356615iwn.8
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 22:39:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298902173.29377.40.camel@macbook.infradead.org>
References: <1298900612-22104-1-git-send-email-shahar_levi@ti.com>
	<1298900612-22104-3-git-send-email-shahar_levi@ti.com>
	<1298902173.29377.40.camel@macbook.infradead.org>
Date: Tue, 1 Mar 2011 08:39:19 +0200
Message-ID: <AANLkTikmzcXa4jGCUv=ttVF5NdnhS5=EBWNuS1R5t_sU@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] linux-firmware: wl12xx-Update AP Firmware
From: "Levi, Shahar" <shahar_levi@ti.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 28, 2011 at 4:09 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2011-02-28 at 15:43 +0200, Shahar Levi wrote:
>> Update AP firmware to version 6.2.0.0.36
>>
>> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> ---
>> Changes from v1:
>>  - Gather to series (No change in patch)
>
> Applying: linux-firmware: wl12xx-Update AP Firmware
> error: patch failed: WHENCE:1467
> error: WHENCE: patch does not apply
> Patch failed at 0001 linux-firmware: wl12xx-Update AP Firmware
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort".
>
>
>>
>> WHENCE                           |    2 +-
>>  ti-connectivity/wl1271-fw-ap.bin |  Bin 260992 -> 262356 bytes
>>  2 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/WHENCE b/WHENCE
>> index 1f25c84..0b882ae 100644
>> --- a/WHENCE
>> +++ b/WHENCE
>> @@ -1467,7 +1467,7 @@ Licence: See LICENCE.ti-connectivity for details.
>>
>>       Station:      wl1271-fw.bin version 6.1.0.50.350 (RM version 206)
>>       Station:      wl1271-fw-2.bin version 6.1.3.50.55
>> -     Access Point: wl1271-fw-ap.bin version 6.2.0.0.30 (RM version 6.2.0.0.6)
>> +     Access Point: Access Point: wl1271-fw-ap.bin version 6.2.0.0.36
>>
>>       The nvs file includes two parts:
>
> That part ('Access Point: Access Point:') probably wasn't what you
> intended anyway? Can you send another version against what I just pushed
> out?
Yes, I am sending now.

All the best,
Shahar
>
>
> --
> dwmw2
>
>
