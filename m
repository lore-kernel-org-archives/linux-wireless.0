Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47814 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1LOOk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 09:40:28 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so1560695vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 06:40:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKeTQ4Z4e5wFXUEkOONsJD4Os=yFDMNVsUXKKobV-Q0=C70u3w@mail.gmail.com>
References: <CAKeTQ4aVzp3GTmzR0zv1j5fWyCUrQLUk9EHHBvZFpDYiQSC1=g@mail.gmail.com>
	<CAD2nsn0jgoUDf02UrajQyOKZiETMEbP6ikBAtBNdmcgT6m34yw@mail.gmail.com>
	<CAKeTQ4adxsEiEzL1DXUvKCF6odfZkQTFhVFJC4AFwBshU-YHFw@mail.gmail.com>
	<CAD2nsn0Zqw0zdEUrMCnBKKLsZEBw_qqT5MO=7dHCwj8Hd6WpqQ@mail.gmail.com>
	<CAD2nsn2fSehL_3ntoQDN0qzfSycx_hLP7R2Nn2V+iaubc5RX4A@mail.gmail.com>
	<CAD2nsn0-OgCvHtx+xHeDtHEJK7s1svxt5jzLmkZNn-huaN3y5g@mail.gmail.com>
	<CAD2nsn3rNcd8_Wa1A-K0r1cQA4HZzWKUFp+zGr2QFnz8phDOkw@mail.gmail.com>
	<CAKeTQ4Z4e5wFXUEkOONsJD4Os=yFDMNVsUXKKobV-Q0=C70u3w@mail.gmail.com>
Date: Thu, 15 Dec 2011 20:10:28 +0530
Message-ID: <CAD2nsn3Zc8Lf3+yMJtdqLtJ7Z_FQVGvZ6apk7B_oDAD+sWtkXg@mail.gmail.com> (sfid-20111215_154031_860946_89B46E1D)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ashwin Mendonca <ashwinloyal@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 8:05 PM, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
> Kernel panic happened after compiling and installing from the patched
> sources. I applied the patch, and it said "main.c was patched". I
> compiled ath9k drivers with this command:

are you sure ?, can you please apply the patch with the compat
wireless package and recompile/install it.  i just tested with this
patch for few mins. i will re-check it

>
> checkinstall make KLIB=/lib/modules/3.1.5-custom install=no
>
> It created a deb file. I installed the deb file. Booted into
> linux-3.1.5 kernel. And ran may AP mode script. First client got
> authenticated. And soon the freeze occurred.
>
> If you want me to do further tests just let me know.
>
> On 12/15/11, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>> On Thu, Dec 15, 2011 at 3:55 PM, Mohammed Shafi
>> <shafi.wireless@gmail.com> wrote:
>>> On Thu, Dec 15, 2011 at 2:36 PM, Mohammed Shafi
>>> <shafi.wireless@gmail.com> wrote:
>>>> On Thu, Dec 15, 2011 at 1:24 PM, Mohammed Shafi
>>>> <shafi.wireless@gmail.com> wrote:
>>>>> On Thu, Dec 15, 2011 at 12:55 PM, Ashwin Mendonca
>>>>> <ashwinloyal@gmail.com> wrote:
>>>>>> I tried the bleeding edge build of compat-wireless
>>>>>> (compat-wireless-2011-12-14 build) on Linux-3.1.5. It still leads to
>>>>>> kernel
>>>>>> panic. I manually got the AP up with these steps:
>>>
>>> hi Ashwin,
>>>
>>> can you please try the attached patch and it seems to work for me.
>>> please go to your compat directory
>>> cd compat...
>>> then do patch -p1 < ./fix-ar2427-ap-mode-panic.patch
>>
>> this might fix the panic, but i need to verify whether everything else
>> is properly handled for AP ps
>>
>>>
>>> --
>>> shafi
>>
>>
>>
>> --
>> shafi
>>



-- 
shafi
