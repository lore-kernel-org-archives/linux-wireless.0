Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54472 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1LOQFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 11:05:18 -0500
Received: by yenm11 with SMTP id m11so1563185yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 08:05:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKeTQ4ZdwCbxbr0_JmsfOy_-7VxH4OKaNADg01L0pk6=2YVb1A@mail.gmail.com>
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
Date: Thu, 15 Dec 2011 21:35:18 +0530
Message-ID: <CAKeTQ4ZR7H_FQ65s9DQhqW00fuCPfm4sE-H+stDhezb5KUTePw@mail.gmail.com> (sfid-20111215_170523_609133_D9F30AB0)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Ashwin Mendonca <ashwinloyal@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Still it doesn't work. I removed ath directory from kernel module
tree. Rebooted to make sure that default ath9k driver is not loaded.
Installed patched binaries, re-checked if updates dir exists in
current kernel modules tree. Rebooted, enabled AP mode, system froze.

On 12/15/11, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
> Still it doesn't work. I removed ath directory from kernel module tree.
> Rebooted to make sure that default ath9k driver is not loaded. Installed
> patched binaries, re-checked if updates dir exists in current kernel
> modules tree. Rebooted, enabled AP mode, system froze.
> On Dec 15, 2011 8:28 PM, "Mohammed Shafi" <shafi.wireless@gmail.com> wrote:
>
>> On Thu, Dec 15, 2011 at 8:24 PM, Ashwin Mendonca <ashwinloyal@gmail.com>
>> wrote:
>> > Now I am recompiling against linux-3.0.0.14. Also I will remove
>> > /lib/modules/3.0.0-14-generic/kernel/drivers/net/wireless/ath and
>> > reinstall compat-wireless binaries and I will let you know.
>>
>> thanks! should be installed in something like this
>> /lib/modules/2.6.32-25-generic/updates/drivers/net/wireless/ath/ath9k
>>
>> --
>> shafi
>>
>
