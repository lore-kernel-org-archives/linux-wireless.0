Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44516 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819Ab1LONSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 08:18:46 -0500
Received: by vbbfc26 with SMTP id fc26so1492713vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 05:18:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn0-OgCvHtx+xHeDtHEJK7s1svxt5jzLmkZNn-huaN3y5g@mail.gmail.com>
References: <CAKeTQ4aVzp3GTmzR0zv1j5fWyCUrQLUk9EHHBvZFpDYiQSC1=g@mail.gmail.com>
	<CAD2nsn0jgoUDf02UrajQyOKZiETMEbP6ikBAtBNdmcgT6m34yw@mail.gmail.com>
	<CAKeTQ4adxsEiEzL1DXUvKCF6odfZkQTFhVFJC4AFwBshU-YHFw@mail.gmail.com>
	<CAD2nsn0Zqw0zdEUrMCnBKKLsZEBw_qqT5MO=7dHCwj8Hd6WpqQ@mail.gmail.com>
	<CAD2nsn2fSehL_3ntoQDN0qzfSycx_hLP7R2Nn2V+iaubc5RX4A@mail.gmail.com>
	<CAD2nsn0-OgCvHtx+xHeDtHEJK7s1svxt5jzLmkZNn-huaN3y5g@mail.gmail.com>
Date: Thu, 15 Dec 2011 18:48:46 +0530
Message-ID: <CAD2nsn3rNcd8_Wa1A-K0r1cQA4HZzWKUFp+zGr2QFnz8phDOkw@mail.gmail.com> (sfid-20111215_141857_920156_10CFD3D6)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ashwin Mendonca <ashwinloyal@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 3:55 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Thu, Dec 15, 2011 at 2:36 PM, Mohammed Shafi
> <shafi.wireless@gmail.com> wrote:
>> On Thu, Dec 15, 2011 at 1:24 PM, Mohammed Shafi
>> <shafi.wireless@gmail.com> wrote:
>>> On Thu, Dec 15, 2011 at 12:55 PM, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
>>>> I tried the bleeding edge build of compat-wireless
>>>> (compat-wireless-2011-12-14 build) on Linux-3.1.5. It still leads to kernel
>>>> panic. I manually got the AP up with these steps:
>
> hi Ashwin,
>
> can you please try the attached patch and it seems to work for me.
> please go to your compat directory
> cd compat...
> then do patch -p1 < ./fix-ar2427-ap-mode-panic.patch

this might fix the panic, but i need to verify whether everything else
is properly handled for AP ps

>
> --
> shafi



-- 
shafi
