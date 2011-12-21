Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38400 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LUPEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 10:04:54 -0500
Received: by vbbfc26 with SMTP id fc26so5850370vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 07:04:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn0tR82TftiSGuXtRrMYPwwbHFJ6OGXNSE5t2OPgv=eD1g@mail.gmail.com>
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
	<CAD2nsn0tR82TftiSGuXtRrMYPwwbHFJ6OGXNSE5t2OPgv=eD1g@mail.gmail.com>
Date: Wed, 21 Dec 2011 20:34:53 +0530
Message-ID: <CAD2nsn1+w6ZSBGaXRWSC2LXupxGuyeLc+rNf5XbFx9giyHZfSw@mail.gmail.com> (sfid-20111221_160458_073473_352DE083)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ashwin Mendonca <ashwinloyal@gmail.com>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ashwin,

even though that fix had worked, i am need some time to make sure the
fix is not a workaround as those driver call back are called from AP
power save handling for clients. let me quickly try to fix it in a
proper way. thanks

-- 
shafi
