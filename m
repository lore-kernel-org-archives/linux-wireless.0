Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:33710 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbdDLRcU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 13:32:20 -0400
Received: by mail-pg0-f52.google.com with SMTP id x125so18020273pgb.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 10:32:19 -0700 (PDT)
Date: Wed, 12 Apr 2017 10:32:16 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH v3 4/4] mwifiex: pcie: extract wifi part from combo
 firmware during function level reset
Message-ID: <20170412173215.GA11609@google.com> (sfid-20170412_193224_439787_ECFDFB4E)
References: <1491815374-6555-1-git-send-email-huxinming820@gmail.com>
 <1491815374-6555-4-git-send-email-huxinming820@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491815374-6555-4-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

One more thing, since you need to update this patchset anyway:

On Mon, Apr 10, 2017 at 09:09:34AM +0000, Xinming Hu wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> A seperate wifi-only firmware was download during pcie function level reset.

You might consider running checkpatch.pl on your submissions. It's
helpful in general, but in this case, it would actually catch a spelling
error:

s/seperate/separate/

> It is in fact the tail part of wifi/bt combo firmware. Per Brian's and
> Dmitry's suggestion, this patch extract the wifi part from combo firmware.
> 
> After that, we can discard the redudant image in linux-firmware repo.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Brian
