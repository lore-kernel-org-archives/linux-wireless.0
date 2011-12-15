Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60207 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1LOO6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 09:58:11 -0500
Received: by vcbfk14 with SMTP id fk14so1570126vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 06:58:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKeTQ4bDyVbY6ZzLJot0_tUdK-1F7ibOv3kpwNDN15kkcBbyiA@mail.gmail.com>
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
Date: Thu, 15 Dec 2011 20:28:10 +0530
Message-ID: <CAD2nsn19BHLbqBvWrU+udjk1nxNvhi7UWA4Vpz8UjjsD+6FjNg@mail.gmail.com> (sfid-20111215_155815_139310_7BF12EB6)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ashwin Mendonca <ashwinloyal@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 8:24 PM, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
> Now I am recompiling against linux-3.0.0.14. Also I will remove
> /lib/modules/3.0.0-14-generic/kernel/drivers/net/wireless/ath and
> reinstall compat-wireless binaries and I will let you know.

thanks! should be installed in something like this
/lib/modules/2.6.32-25-generic/updates/drivers/net/wireless/ath/ath9k

-- 
shafi
