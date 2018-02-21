Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:43281 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965023AbeBUPfQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 10:35:16 -0500
Received: by mail-qk0-f194.google.com with SMTP id i184so2430756qkf.10
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2018 07:35:15 -0800 (PST)
Subject: Re: [RFC PATCH 0/2] net: rfkill: gpio: Fix and support SerDev
To: Carlo Caione <carlo@endlessm.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Fr=c3=a9d=c3=a9ric_Danis?= <frederic.danis.oss@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Upstreaming Team <linux@endlessm.com>
References: <20180220134618.12972-1-carlo@caione.org>
 <31f0157f-4778-2f9c-977f-8bdbba6f52a4@redhat.com>
 <CAL9uMOEFm4apUrDxs6GkZqV2S=mepd2Ytcna+SCaLnCcwtcfeg@mail.gmail.com>
 <c1f7d6a5-7b31-e3e2-870c-ccc0dd2fca20@redhat.com>
 <CAFBinCCc6yAWgVm85gTeGr_=y0B=H0j1et1r=V10ycX4pKCZVg@mail.gmail.com>
 <9c385301-dae6-9d7c-a510-2b210eaf05bc@redhat.com>
 <CAL9uMOHfcUOJOOVp6snnvy2bNDZA_T9Hyi2NCLCEayR2DGCkCg@mail.gmail.com>
From: Jeremy Cline <jcline@redhat.com>
Message-ID: <22de70c0-0a7c-c6a9-0d1b-3fa1f7519222@redhat.com> (sfid-20180221_163523_312601_B08060F1)
Date: Wed, 21 Feb 2018 10:35:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAL9uMOHfcUOJOOVp6snnvy2bNDZA_T9Hyi2NCLCEayR2DGCkCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2018 04:34 PM, Carlo Caione wrote:
> On Tue, Feb 20, 2018 at 9:18 PM, Jeremy Cline <jcline@redhat.com> wrote:
> 
>> Great, thanks for all the info! I'll definitely keep you CC'ed on my
>> progress. I'm still very new to kernel development so I expect it'll
>> take me quite a while, but I do have a fair bit of time to devote to
>> this.
> 
> Welcome to this crazy world ;)

Thanks!

> Keep me on CC also, I have quite a bit of hw I can test the patches
> on. Fell free also to reach me in private.
> I was actually going to work on this myself but now I guess there are
> too many people.

Will do. As for too many people, that's a pretty good problem to have!
It sounds like Martin is pretty busy, though, and I would welcome your
help. I was going to start by rebasing the current RFC and then looking
at adding ACPI support since that sounds pretty straight-forward and I
have the hardware.

Figuring out the mysteries of the config blob and creating an H5
"library" sound fairly independent to me so if you're interested maybe
we could both take one on.

Regards,
Jeremy
