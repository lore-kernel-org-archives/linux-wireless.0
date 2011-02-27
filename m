Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57639 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1B0VmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 16:42:23 -0500
Received: by qwd7 with SMTP id 7so2421387qwd.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 13:42:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D628D75.1070907@lwfinger.net>
References: <AANLkTinoU0Dxy2iAHEsprTbakrbs8a8vPARFW0odz4g9@mail.gmail.com> <4D628D75.1070907@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 27 Feb 2011 22:42:02 +0100
Message-ID: <AANLkTi=RaQonkove9=BrRJFpf+Oc3qkq29sNkxvwRP7w@mail.gmail.com>
Subject: Re: Realtek RTL8192SE support ? (aka r8192se_pci)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mathieu Malaterre <mathieu.malaterre@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 5:06 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 02/21/2011 03:35 AM, Mathieu Malaterre wrote:
>>
>> Dear all,
>>
>>   As far as I know driver for rtl8192su will be added to kernel
>> 2.6.38. By any chance does anyone knows if rtl8192se will make it into
>> this release ?
>
> As part of our collaborative effort, Realtek has sent me a mac80211-based
> driver for the RTL8192SE. It will be submitted to the wireless mailing list
> for review once the driver for the RTL8192CU is accepted. The earliest this
> would happen is 2.6.39, but I think 2.6.40 is more realistic. I also have a
> driver for the RTL8192DE that will follow the RTL8192SE.

Is there any reason why you are holding back release of these drivers?
You know, the general Linux practice is release-early-release-often...

>
> The driver for the RTRL8192SU does not use mac80211 and is in 2.6.37. It is
> known as r8712u.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
