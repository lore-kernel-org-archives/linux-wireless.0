Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51989 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2BVOtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 09:49:49 -0500
Received: by bkcjm19 with SMTP id jm19so118760bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2012 06:49:47 -0800 (PST)
Message-ID: <4F450086.5000000@gmail.com> (sfid-20120222_154953_141775_6A46CF91)
Date: Wed, 22 Feb 2012 15:49:42 +0100
From: =?UTF-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <m.hundeboll@gmail.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: compat-wireless-2012-02-21 compilation issue (2.6.35-32)
References: <CAFED-j=pt4zyuWP9g6rhjzDDwxmrw01w1Lek=k5i7rzekezpAA@mail.gmail.com>
In-Reply-To: <CAFED-j=pt4zyuWP9g6rhjzDDwxmrw01w1Lek=k5i7rzekezpAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 02/22/2012 03:23 PM, Janusz Dziedzic wrote:
> I have compilation issue.
> Is there any patch available?

I see the same thing on 3.2.6. Fetching the latest stable instead worked for me.

> jadz@uw000950:~/builds/community/compat-wireless-2012-02-21$ make
> make -C /lib/modules/2.6.35-32-generic/build
> M=/home/xpujadz/builds/community/compat-wireless-2012-02-21 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.35-32-generic'
>    Building modules, stage 2.
>    MODPOST 9 modules
> WARNING: "__tracepoint_drv_return_void"
> [/home/xpujadz/builds/community/compat-wireless-2012-02-21/net/mac80211/mac80211.ko]
> undefined!
> WARNING: "__tracepoint_drv_bss_info_changed"
> [/home/xpujadz/builds/community/compat-wireless-2012-02-21/net/mac80211/mac80211.ko]
> undefined!
> WARNING: "__tracepoint_api_stop_tx_ba_session"
> [/home/xpujadz/builds/community/compat-wireless-2012-02-21/net/mac80211/mac80211.ko]
> undefined!
> WARNING: "__tracepoint_drv_configure_filter"
> [/home/xpujadz/builds/community/compat-wireless-2012-02-21/net/mac80211/mac80211.ko]
> undefined!
>
> uname:
> Linux uw000950 2.6.35-32-generic #64~lucid1-Ubuntu SMP Tue Jan 3
> 15:41:36 UTC 2012 x86_64 GNU/Linux
>
> BR
> Janusz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

