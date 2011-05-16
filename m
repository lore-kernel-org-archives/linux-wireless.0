Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61848 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1EPUQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 16:16:12 -0400
Received: by qyk7 with SMTP id 7so1707341qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 13:16:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinWLd18arAye-4KVpicoJAqThWoJw@mail.gmail.com>
References: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>
 <4DCB3DFF.1030809@lockie.ca> <BANLkTimEWJbgJJOmCjBoNGtFrSFcoE8aWQ@mail.gmail.com>
 <4DCE9DB8.7080404@lwfinger.net> <BANLkTikHk=yVQ64OJKBcC9QtYP6OOGrmPw@mail.gmail.com>
 <BANLkTi=07Ovr6UcuT6ctG_3NZ7kxFY+txA@mail.gmail.com> <4DD0518D.1090300@lwfinger.net>
 <BANLkTikRG61T==_K1sYF4bH=8xC8NwYwhA@mail.gmail.com> <4DD13AA2.1000206@lwfinger.net>
 <BANLkTinWLd18arAye-4KVpicoJAqThWoJw@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 16 May 2011 22:15:51 +0200
Message-ID: <BANLkTimb24zCF9AoN7iaXwn5J46RMsmhVg@mail.gmail.com> (sfid-20110516_221615_576409_BE1B12CB)
Subject: Re: rtl8192ce.ko doesn't work with 802.11n?
To: Flaminigo <sunnyiez@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	James <bjlockie@lockie.ca>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 16, 2011 at 5:20 PM, Flaminigo <sunnyiez@gmail.com> wrote:
> Hi,
>    I appreciate your help greatly. I am not very familiar with kernel
> programming. Actually, I am a graphics guy. I try to apply your patch
> but I failed. That was my process. FYI
>
> 1. Download RC7 code from
> http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.39-rc7.tar.bz2
> 2. Download the patch from
> http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.39-rc7.bz2
> 3. apply the patch.
> sunny@samunder:~/Downloads/kernel/linux-2.6.39-rc7$ bzip2 -dc
> patch-2.6.39-rc7.bz2  | patch -p1

You do not need this patch at all - it is already integrated into
linux-2.6.39-rc7.tar.bz2. The patch is for those who already
downloaded the linux-2.6.38 sources, and do not want to redownload a
kernel source tree (also, historically there was no
linux-whatever-rcX.tar.bz2, pre-releases were only distributed as
patches to the previous stable kernel).

> 4. copy and paste your patch
> https://bugzilla.kernel.org/attachment.cgi?id=57802 and place it in
> file `pa`
> 5. apply your patch by patch -p1 < pa.
>
> I failed :(
>
>
>
> On Mon, May 16, 2011 at 9:54 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 05/16/2011 08:48 AM, Flaminigo wrote:
>>>
>>> I looked the patch you sent me. The patch is applied on 2.6.39-rc1,
>>> right? I browse the www.kernel.org but I cannot find the source code
>>> for RC1.
>>> What should I  do ? Find the RC1 code. Apply your patch. Recompile the
>>> kernel and install it? I appreciate your help.
>>
>> At the moment, you should get 2.6.39-rc7 sources, apply the patch, and build
>> that kernel. The patch should apply for any of the ...39-rcX kernels, but I
>> did in fact test it with rc7.
>>
>> Larry
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
