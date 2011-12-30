Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57471 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1L3Ug5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 15:36:57 -0500
Received: by vbbfc26 with SMTP id fc26so10989334vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Dec 2011 12:36:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E1RgiLY-0007Df-Fb@pf14.m5r2.onet>
References: <E1RgiLY-0007Df-Fb@pf14.m5r2.onet>
Date: Fri, 30 Dec 2011 21:36:56 +0100
Message-ID: <CAAfyv37h1LMTvtBGrJy5URh5BFxVVHWTqoUhQGRsGJz6s2xKYA@mail.gmail.com> (sfid-20111230_213701_569514_D2C3D93C)
Subject: Re: ipw2200 problem
From: Belisko Marek <marek.belisko@gmail.com>
To: forlab@op.pl
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 30, 2011 at 8:42 PM,  <forlab@op.pl> wrote:
> Hi!
> I'm having problems using this adapter Intel Corporation PRO/Wireless 2915ABG [Calexico2] with backtrack 5. After I
>
> dmesg | grep error
>
>  the only error message I get is this:
> [   38.771895] ipw2200: probe of 0000:03:03.0 failed with error -5
>
> From:
> dmesg | grep ipw2200
> [   38.628681] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
> [   38.628687] ipw2200: Copyright(c) 2003-2006 Intel Corporation
> [   38.628802] ipw2200 0000:03:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   38.628832] ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
> [   38.771793] ipw2200: ipw2200-bss.fw request_firmware failed: Reason -2
-2 = ENOENT which means no such file or directory. Do you have
ipw2200-bss.fw in /lib/firmware?
What distro your'e using?
> [   38.771800] ipw2200: Unable to load firmware: -2
> [   38.771804] ipw2200: failed to register network device
> [   38.771846] ipw2200 0000:03:03.0: PCI INT A disabled
> [   38.771895] ipw2200: probe of 0000:03:03.0 failed with error -5
>
> I searched the web, but no help there.... Any idea?
>
> regards
> Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
