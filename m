Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47476 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab2HIS3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:29:09 -0400
Received: by lboi8 with SMTP id i8so448939lbo.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:29:07 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
Date: Thu, 9 Aug 2012 20:29:07 +0200
Message-ID: <CA+icZUWTjKYQ5YZfx488=SJA-uYYoRvM5X=Gh0YOHn8SvUM2jg@mail.gmail.com> (sfid-20120809_202914_669040_E2CF2139)
Subject: Re: [PATCH 00/13] Merge GSoC DRM changes to admin-update.sh
From: Sedat Dilek <sedat.dilek@gmail.com>
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 9, 2012 at 8:01 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Hi,
>
> The patches below modifies the admin-update.sh script so that it
> accepts a variable-length last argument, namely network or/and drm,
> to selectively fetch specific subsystem codes into the tree.
>
> The last 2 patches constitutes the work done so far for the my
> GSoC project.
>
> This first attempt is mostly for getting some comments. For example,
> eventhough you fetch network and drm drivers, make will just build
> network drivers. I will either port the project to kconfig which
> will dynamically configure and build what's available or hack
> config.mk and Makefile to detect the availability of other drivers
> than the wireless ones.
>
> I thank Luis R. Rodriguez, my mentor, for his helpful and highly
> responsive mentorship :)
>
> Ozan Çağlayan (13):
>   compat-wireless: Clean up *.mod.c once after everything
>   compat-wireless: Isolate drivers into different groups
>   compat-wireless: List everything vertically without concatenating
>   compat-wireless: Add ability to enable/disable subsystems
>   compat-wireless: Add 2 convenience functions
>   compat-wireless: Conditionally build network drivers
>   compat-wireless: Put network patches into its directory
>   compat-wireless: No need to search for patches
>   compat-wireless: Fix cmdline parameter's name
>   compat-wireless: Selectively apply patches
>   compat-wireless: Move refresh logic into the loop
>   compat-wireless: Fetch in DRM drivers
>   compat-wireless: Add DRM patches
>

Am I the only one missing 07/13 in series?
On [1] I do not see, too.

- "Birinci" Sedat -

[1] http://marc.info/?l=linux-wireless&r=1&b=201208&w=2

- Sedat -
