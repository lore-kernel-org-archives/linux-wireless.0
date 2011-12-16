Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60082 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1LPGoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 01:44:00 -0500
Received: by vcbfk14 with SMTP id fk14so2214103vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 22:43:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKeTQ4biY55BtRhNmXFGeN2Yrr6mJTi2c8h30BkPx=f+i9mpww@mail.gmail.com>
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
	<CAKeTQ4biY55BtRhNmXFGeN2Yrr6mJTi2c8h30BkPx=f+i9mpww@mail.gmail.com>
Date: Fri, 16 Dec 2011 12:13:59 +0530
Message-ID: <CAD2nsn0tR82TftiSGuXtRrMYPwwbHFJ6OGXNSE5t2OPgv=eD1g@mail.gmail.com> (sfid-20111216_074404_318695_BAE1A380)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ashwin Mendonca <ashwinloyal@gmail.com>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 16, 2011 at 11:10 AM, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
> It works. Sorry for messing up. I have been installing more than 10
> kernels ( to get the AP mode working). I use checkinstall to create a
> deb package of drivers. But ckeckinstall was installing the module in
> the module tree of an older kernel. So I used make install to install
> the kernel in the current active kernel module tree. And I did not get
> a freeze when I loaded the newer ath9k driver. Thank you very much.

thanks a lot for testing. for testing wireless drivers in a quick way
you can install latest compat-wireless in some standard Ubuntu
versions

>
> If you want me to test it a little more, i can do it
>

I need to look into the code to make sure, it does not breaks power
save handling in AP mode for AR2427, after that i would like to send
the patch.  please use this patch for time being to do any tests you
would prefer like sending UDP traffic to clients etc.
thank you.

-- 
shafi
