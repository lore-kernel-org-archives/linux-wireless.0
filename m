Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33247 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab0LABhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 20:37:18 -0500
Received: by iwn10 with SMTP id 10so442363iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 17:37:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimUpxb+qaCerwgxqcz5iOmFz7MaZFhFPSOxJd1M@mail.gmail.com>
References: <AANLkTi=6NGw3GTnX+vEqx_iHcDb4SUmPc5vvndyMc=5s@mail.gmail.com>
 <AANLkTinMBx=5J4ZAaO7qkmJAxp4xbjoJxq+m+Bjz+K1e@mail.gmail.com> <AANLkTimUpxb+qaCerwgxqcz5iOmFz7MaZFhFPSOxJd1M@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 30 Nov 2010 17:36:57 -0800
Message-ID: <AANLkTikCrcpbyNEL94Jo9OsvcaEguKfN6-9nheZ=Sa8Q@mail.gmail.com>
Subject: Re: wl1271: power down/up sequence
To: Joerie de Gram <j.de.gram@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 3:30 PM, Joerie de Gram <j.de.gram@gmail.com> wrote:
> The regulator is only enabled once. Equally, the MMC interface is
> initialised only at boot, and remains untouched afterwards.

Even if the wl12xx sdio driver is still not loaded ?

Can you pls send me your drivers/mmc/core/sdio.c to have a look ? Or
probably better, can you share the entire kernel ? and your .config ?

Thanks,
Ohad.
