Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39202 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab0EYB06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 21:26:58 -0400
Received: by fxm5 with SMTP id 5so2790464fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 18:26:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTil4AnMqzSN4d_VTRJGFqWQl7CkZtr80GcffqM3h@mail.gmail.com>
References: <4BFB21C1.3060703@gmail.com> <AANLkTil4AnMqzSN4d_VTRJGFqWQl7CkZtr80GcffqM3h@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 25 May 2010 03:26:37 +0200
Message-ID: <AANLkTilGK0jIqYDYQBP7RgJ6b_3Pk7FEbo4S7n6e-4Ly@mail.gmail.com>
Subject: Re: ioctl for b43 driver
To: Huy Le <lehuy0406@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/25 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Tue, May 25, 2010 at 3:02 AM, Huy Le <lehuy0406@gmail.com> wrote:
>> Hi,
>>
>> Currently I try aircrack-ng with b43 driver but it is fail at this statement
>> due to the following statement:
>>
>>    ioctl( fd, SIOCGIWFREQ, &wrq ) < 0
>>
>> This happens because we do not have ioctl for b43 driver. I just want to ask
>> if there is any way to work around.
>
> Confirmed with ath9k. Apparently rdev->channel is NULL for monitor interfaces.

I meant wdev->channel - it got changed recently.

>
>>
>> Thanks.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
