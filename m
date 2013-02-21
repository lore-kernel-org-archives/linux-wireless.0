Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53884 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3BUSoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 13:44:24 -0500
Received: by mail-ob0-f175.google.com with SMTP id uz6so9033486obc.6
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2013 10:44:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130221121722.GA23690@odin.tremily.us>
References: <20130221121722.GA23690@odin.tremily.us>
Date: Thu, 21 Feb 2013 19:44:23 +0100
Message-ID: <CACna6rwyDodWUtSuL+-Ts_bD=LDE061Xk7O+3KfhTAs3x2tTNw@mail.gmail.com> (sfid-20130221_194428_869288_79D47D71)
Subject: Re: rev-17 Broadcom core support in b43 and CONFIG_B43_BCMA_EXTRA
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "W. Trevor King" <wking@tremily.us>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/2/21 W. Trevor King <wking@tremily.us>:
> I've been poking around in b43 and brcmsmac trying to wrap my head
> around device detection.  Obviously, b43 and brcmsmac both support
> some devices, and since 4f3d09d (b43: add option to avoid duplicating
> device support with brcmsmac, 2012-01-11) overlapping devices have
> been masked behind CONFIG_B43_BCMA_EXTRA.  At the time of that commit,
> brcmsmac didn't support the r17 cores, but support has since been
> added in 6f80f01 (brcmsmac: add support for cores with revision 17,
> 2012-12-07).  Does that mean that b43 should move the r17 core entry
> into the masked-by-CONFIG_B43_BCMA_EXTRA block?

I dislike CONFIG_B43_BCMA_EXTRA from the beginning, it should be
selectable as kernel-option according to me. Forcing user to recompile
the kernel, just to test a driver, sound like a really poor
user-friendliness to me.

-- 
Rafał
