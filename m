Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32954 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0LAKkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 05:40:36 -0500
Received: by qwb7 with SMTP id 7so6909267qwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 02:40:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikCrcpbyNEL94Jo9OsvcaEguKfN6-9nheZ=Sa8Q@mail.gmail.com>
References: <AANLkTi=6NGw3GTnX+vEqx_iHcDb4SUmPc5vvndyMc=5s@mail.gmail.com>
 <AANLkTinMBx=5J4ZAaO7qkmJAxp4xbjoJxq+m+Bjz+K1e@mail.gmail.com>
 <AANLkTimUpxb+qaCerwgxqcz5iOmFz7MaZFhFPSOxJd1M@mail.gmail.com> <AANLkTikCrcpbyNEL94Jo9OsvcaEguKfN6-9nheZ=Sa8Q@mail.gmail.com>
From: Joerie de Gram <j.de.gram@gmail.com>
Date: Wed, 1 Dec 2010 11:40:14 +0100
Message-ID: <AANLkTikcngkX=a24r=uQKXgBjABQzZn_Hz3H2bvuiU8e@mail.gmail.com>
Subject: Re: wl1271: power down/up sequence
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Dec 1, 2010 at 2:36 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Nov 30, 2010 at 3:30 PM, Joerie de Gram <j.de.gram@gmail.com> wrote:
>> The regulator is only enabled once. Equally, the MMC interface is
>> initialised only at boot, and remains untouched afterwards.
>
> Even if the wl12xx sdio driver is still not loaded ?

Yes.

> Can you pls send me your drivers/mmc/core/sdio.c to have a look ? Or
> probably better, can you share the entire kernel ? and your .config ?

I have pushed my development tree to:
http://h1.pargon.nl/gitweb/gitweb.cgi?p=kernel.git;a=shortlog;h=refs/heads/wireless
Board is called board-nowplus, current config is nowplus_defconfig.

Joerie
