Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36369 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2GCUnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 16:43:15 -0400
Received: by pbbrp8 with SMTP id rp8so9790198pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 13:43:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341345818-24924-1-git-send-email-ozancag@gmail.com>
References: <1341345818-24924-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 3 Jul 2012 13:42:54 -0700
Message-ID: <CAB=NE6V+=iwuEk=du4HzF-1KhWnbGu9ea11hXZ5tiMEFcYGhvQ@mail.gmail.com> (sfid-20120703_224318_903254_A16FE9E9)
Subject: Re: [PATCH] compat: Backport cpufreq_quick_get_max()
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 1:03 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> This backports:
>
> commit 3d73710880afa3d61cf57b5d4eb192e812eb7e4f
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Tue Jun 28 10:59:12 2011 -0700
>
>   cpufreq: expose a cpufreq_quick_get_max routine
>
> Trying kernel  3.4.0-030400-generic [OK]
> Trying kernel  3.3.7-030307-generic [OK]
> Trying kernel  3.2.2-030202-generic [OK]
> Trying kernel  3.1.10-030110-generic [OK]
> Trying kernel  3.0.18-030018-generic [OK]
> Trying kernel  2.6.39-02063904-generic [OK]
> Trying kernel  2.6.38-02063808-generic [OK]
> Trying kernel  2.6.37-02063706-generic [OK]
> Trying kernel  2.6.36-02063604-generic [OK]
> Trying kernel  2.6.35-02063512-generic [OK]
> Trying kernel  2.6.34-02063410-generic [OK]
> Trying kernel  2.6.33-02063305-generic [OK]
> Trying kernel  2.6.32-02063255-generic [OK]
> Trying kernel  2.6.31-02063113-generic [OK]
> Trying kernel  2.6.30-02063010-generic [OK]
> Trying kernel  2.6.29-02062906-generic [OK]
> Trying kernel  2.6.28-02062810-generic [OK]
> Trying kernel  2.6.27-020627-generic [OK]
> Trying kernel  2.6.26-020626-generic [OK]
> Trying kernel  2.6.25-020625-generic [OK]
> Trying kernel  2.6.24-020624-generic [OK]
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Thanks, applied and pushed, next time if you can add in the commit log
something like this:

mcgrof@tux ~/linux-stable (git::master)$ git describe --contains
3d73710880afa3d61cf57b5d4eb192e812eb7e4f
v3.1-rc1~230^2~18^2~36

That would prove this was introduced in 3.1 and that compat-3.1.[ch]
are the right files to be modifying.

Thanks!

  Luis
