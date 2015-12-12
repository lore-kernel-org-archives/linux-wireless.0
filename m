Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:35110 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbLLArS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 19:47:18 -0500
Received: by qkfb125 with SMTP id b125so64125403qkf.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2015 16:47:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANEJEGv7ENTJu4YHz1x2_ve2M6-3Nn8X-0aC2hA3o1mUs3tQ1g@mail.gmail.com>
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
	<1448018530.3141.25.camel@sipsolutions.net>
	<CANEJEGv7ENTJu4YHz1x2_ve2M6-3Nn8X-0aC2hA3o1mUs3tQ1g@mail.gmail.com>
Date: Fri, 11 Dec 2015 16:47:17 -0800
Message-ID: <CANEJEGvewNOsVrHSZXbR-rU58NH9D4vouzskK6VHG9LuxAF1Cw@mail.gmail.com> (sfid-20151212_014725_579985_B04F4255)
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
From: Grant Grundler <grundler@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Lin <dlin@marvell.com>, Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[resending as plain text....gmail...grrrh.]

On Fri, Dec 11, 2015 at 4:46 PM, Grant Grundler <grundler@google.com> wrote:
> Sorry for the late response...just one point below
>
> On Fri, Nov 20, 2015 at 3:22 AM, Johannes Berg <johannes@sipsolutions.net>
> wrote:
>>
>> > +#define MWL_DRV_NAME     KBUILD_MODNAME
>> > +#define MWL_DRV_VERSION       "10.3.0.14"
>>
>> versions like that are generally fairly useless since you don't update
>> them for every commit ...
>
>
> When backporting to other kernel trees, it's extremely handy to have a
> DRV_VERSION.
>
> Checking if a particular kernel build has the expected driver version
> trivial.  "mod_info" dumps the driver version for modules (which this will
> usually be too).
>
> And yes, it won't get updated for every commit only because other version
> control might encapsulate those changes. Not every distro makes their build
> versioning accessible to outsiders. So it's still helpful even if not
> perfect.
>
> Marvell can update this every time they resync with their own internal
> versions.
>
> cheers,
> grant
