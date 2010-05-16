Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:12916 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0EPVtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 May 2010 17:49:24 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2454076fga.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 May 2010 14:49:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
References: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 16 May 2010 23:49:03 +0200
Message-ID: <AANLkTim1i3oB10rydr8ezyCjher1yctqKcVt9Ct1Bze0@mail.gmail.com>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
	suite)
To: Weedy <weedy2887@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 16, 2010 at 10:41 PM, Weedy <weedy2887@gmail.com> wrote:
> Running airodump on ubuntus 2.6.30 kernel works as expected. The
> 2.6.32 kernel shipped in lucid never sees data packets.
>
> I have narrowed it down to channel hopping. modprobing the driver and
> starting mon0 on a fixed channel works as expected, but allowing
> airodump to channel hop breaks the interface until the driver is
> reset.
>
> I wrote a script to download and build compat wireless starting from
> 2009-01-01 (granted everything fails until half way through october),
> but every version that is successfully installed also show the same
> bug.
>
> Further instructions welcome.

Try checking out linux-2.6, and doing a bisect between 2.6.30 and 2.6.32.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
