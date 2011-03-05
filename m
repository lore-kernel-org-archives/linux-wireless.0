Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47219 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1CEIRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 03:17:41 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimkoaZqn9SDEuc=vuazzqwA7Jrmz1hiwDWSXhM2@mail.gmail.com>
References: <1299076306-11955-1-git-send-email-geryk@ti.com>
	<AANLkTik5Z_eAA_qWGB_rwoK3P1g4jMnM6hj26fje6JHf@mail.gmail.com>
	<AANLkTimkoaZqn9SDEuc=vuazzqwA7Jrmz1hiwDWSXhM2@mail.gmail.com>
Date: Sat, 5 Mar 2011 13:47:39 +0530
Message-ID: <AANLkTi=fRXHWVeZpR1X5pGAZjPGTt84ZPo1kWkPQhZps@mail.gmail.com>
Subject: Re: [PATCH v2] linux-firmware: Initial release for Bluetooth init script
From: Pavan Savoy <pavan_savoy@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Gery Kahn <gery.kahn@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 5, 2011 at 5:04 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hi Pavan,
>
> On Thu, Mar 3, 2011 at 3:44 PM, Pavan Savoy <pavan_savoy@ti.com> wrote:
>> On Wed, Mar 2, 2011 at 8:01 PM, Gery Kahn <gery.kahn@gmail.com> wrote:
> ...
>> Can we name this in all smaller case?
>
> How is this going to work with smaller case ?

No, Not right away - Since every release the firmware team makes, it
does that by naming it in CamelCase.
So, I was thinking while putting up each new firmware on /lib/ may be
we can make it smaller case - like other firmware....


> AFAICS, Gery used the exact name format that st_kim is looking for:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/misc/ti-st/st_kim.c;h=73b6c8b0e8696db9dbe8a71590bf7b62fb3b5532;hb=HEAD#l261
>
> Do you plan to change st_kim ?
>
> If so, please first change it, and then update the firmware file.

So, yes in case the firmware is going to be freely available from
now-onwards - will post a patch to expect smaller case file name.

Thanks,
Pavan

> Thanks,
> Ohad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
