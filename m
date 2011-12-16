Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46713 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1LPFky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 00:40:54 -0500
Received: by yhr47 with SMTP id 47so2715737yhr.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 21:40:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn26W4Aq+Raw5BKPG5zFf3owH33+hMiQPgd=KXOi=PDTyg@mail.gmail.com>
References: <CAKeTQ4aVzp3GTmzR0zv1j5fWyCUrQLUk9EHHBvZFpDYiQSC1=g@mail.gmail.com>
	<CAD2nsn0jgoUDf02UrajQyOKZiETMEbP6ikBAtBNdmcgT6m34yw@mail.gmail.com>
	<CAKeTQ4adxsEiEzL1DXUvKCF6odfZkQTFhVFJC4AFwBshU-YHFw@mail.gmail.com>
	<CAD2nsn0Zqw0zdEUrMCnBKKLsZEBw_qqT5MO=7dHCwj8Hd6WpqQ@mail.gmail.com>
	<CAD2nsn2fSehL_3ntoQDN0qzfSycx_hLP7R2Nn2V+iaubc5RX4A@mail.gmail.com>
	<CAD2nsn0-OgCvHtx+xHeDtHEJK7s1svxt5jzLmkZNn-huaN3y5g@mail.gmail.com>
	<CAD2nsn3rNcd8_Wa1A-K0r1cQA4HZzWKUFp+zGr2QFnz8phDOkw@mail.gmail.com>
	<CAKeTQ4Z4e5wFXUEkOONsJD4Os=yFDMNVsUXKKobV-Q0=C70u3w@mail.gmail.com>
	<CAD2nsn3Zc8Lf3+yMJtdqLtJ7Z_FQVGvZ6apk7B_oDAD+sWtkXg@mail.gmail.com>
	<CAKeTQ4bDyVbY6ZzLJot0_tUdK-1F7ibOv3kpwNDN15kkcBbyiA@mail.gmail.com>
	<CAD2nsn19BHLbqBvWrU+udjk1nxNvhi7UWA4Vpz8UjjsD+6FjNg@mail.gmail.com>
	<CAKeTQ4ZdwCbxbr0_JmsfOy_-7VxH4OKaNADg01L0pk6=2YVb1A@mail.gmail.com>
	<CAD2nsn26W4Aq+Raw5BKPG5zFf3owH33+hMiQPgd=KXOi=PDTyg@mail.gmail.com>
Date: Fri, 16 Dec 2011 11:10:53 +0530
Message-ID: <CAKeTQ4biY55BtRhNmXFGeN2Yrr6mJTi2c8h30BkPx=f+i9mpww@mail.gmail.com> (sfid-20111216_064057_864973_1D6EF712)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Ashwin Mendonca <ashwinloyal@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It works. Sorry for messing up. I have been installing more than 10
kernels ( to get the AP mode working). I use checkinstall to create a
deb package of drivers. But ckeckinstall was installing the module in
the module tree of an older kernel. So I used make install to install
the kernel in the current active kernel module tree. And I did not get
a freeze when I loaded the newer ath9k driver. Thank you very much.

If you want me to test it a little more, i can do it

On 12/16/11, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> On Thu, Dec 15, 2011 at 9:33 PM, Ashwin Mendonca <ashwinloyal@gmail.com>
> wrote:
>> Still it doesn't work. I removed ath directory from kernel module tree.
>> Rebooted to make sure that default ath9k driver is not loaded. Installed
>> patched binaries, re-checked if updates dir exists in current kernel
>> modules
>> tree. Rebooted, enabled AP mode, system froze.
>
> Oops please wait i will check it out, thanks for your efforts
>
> --
> shafi
>
