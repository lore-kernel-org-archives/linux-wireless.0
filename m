Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35571 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab1EKQwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:52:53 -0400
Received: by ewy4 with SMTP id 4so196990ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 09:52:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305104269.12586.746.camel@cumari>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com> <1305104269.12586.746.camel@cumari>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 11 May 2011 09:52:32 -0700
Message-ID: <BANLkTimuZpe4ifV9NO6qgCw4fkWhfojf9g@mail.gmail.com> (sfid-20110511_185257_254880_8F873A47)
Subject: Re: [PATCH 0/7] wl12xx: add initial wowlan support
To: Luciano Coelho <coelho@ti.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

On Wed, May 11, 2011 at 1:57 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2011-05-11 at 11:54 +0300, Eliad Peller wrote:
>> Note that this patchset needs some additional omap/mmc patches in
>> order to support the MMC_PM_KEEP_POWER flag and wake-irq correctly
>> (however, if the MMC_PM_KEEP_POWER flag is not being supported we
>> don't advertise support for wowlan triggers, so this patchset alone
>> shouldn't harm).
>
> Do you know if these patches are queued in linux-omap for 2.6.40?

Not yet, we wanted first to get driver support for this, and then we'd
start adding the required platform support (for several platforms btw,
not only omap. so we'll start adding them one by one now).

Thanks,
Ohad.
