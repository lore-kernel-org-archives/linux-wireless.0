Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49500 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2KTLtW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:49:22 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so4144992iay.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:49:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 20 Nov 2012 13:49:05 +0200
Message-ID: <CA+XVXfdqzOq5xYt+7UKQQnHUbnyraa73agW8t1mzWCo1M7Toeg@mail.gmail.com> (sfid-20121120_124925_266263_34AE7728)
Subject: Re: [PATCH v2 00/11] wlcore: prepare to multi-channel
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 1:20 PM, Eliad Peller <eliad@wizery.com> wrote:
> Make the connection flow simpler by using only the sta
> role (i.e. no need for dev role).
>
> This is possible now, as we know the AP's BSSID even
> before authentication.
>
> This means we no longer start dev role when the device
> is non-idle, so now we use the .remain_on_channel()
> and start device role only then.
>
> Finally, implement the chanctx callbacks in order to
> have a clear per-vif channel (instead of the global
> hw->channel)
>
> (this patchset depends on
> "mac80211: make remain_on_channel() op pass vif param")
>
> v2: fix some issues pointed out by Arik/Luca (thanks!)
>     squash some patches together (thanks Johannes and Julian!)

You can add my reviewed-by to this patch-set, if you care about this stuff :)

Arik
