Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34520 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbeBTVev (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 16:34:51 -0500
Received: by mail-ua0-f193.google.com with SMTP id m43so9356033uah.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 13:34:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9c385301-dae6-9d7c-a510-2b210eaf05bc@redhat.com>
References: <20180220134618.12972-1-carlo@caione.org> <31f0157f-4778-2f9c-977f-8bdbba6f52a4@redhat.com>
 <CAL9uMOEFm4apUrDxs6GkZqV2S=mepd2Ytcna+SCaLnCcwtcfeg@mail.gmail.com>
 <c1f7d6a5-7b31-e3e2-870c-ccc0dd2fca20@redhat.com> <CAFBinCCc6yAWgVm85gTeGr_=y0B=H0j1et1r=V10ycX4pKCZVg@mail.gmail.com>
 <9c385301-dae6-9d7c-a510-2b210eaf05bc@redhat.com>
From: Carlo Caione <carlo@endlessm.com>
Date: Tue, 20 Feb 2018 21:34:50 +0000
Message-ID: <CAL9uMOHfcUOJOOVp6snnvy2bNDZA_T9Hyi2NCLCEayR2DGCkCg@mail.gmail.com> (sfid-20180220_223455_446219_B6B4C577)
Subject: Re: [RFC PATCH 0/2] net: rfkill: gpio: Fix and support SerDev
To: Jeremy Cline <jcline@redhat.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        =?UTF-8?B?RnLDqWTDqXJpYyBEYW5pcw==?= <frederic.danis.oss@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 20, 2018 at 9:18 PM, Jeremy Cline <jcline@redhat.com> wrote:

> Great, thanks for all the info! I'll definitely keep you CC'ed on my
> progress. I'm still very new to kernel development so I expect it'll
> take me quite a while, but I do have a fair bit of time to devote to
> this.

Welcome to this crazy world ;)
Keep me on CC also, I have quite a bit of hw I can test the patches
on. Fell free also to reach me in private.
I was actually going to work on this myself but now I guess there are
too many people.

Cheers,

-- 
Carlo Caione  |  +44.7384.69.16.04  |  Endless
