Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37374 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937278AbdIZR3g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 13:29:36 -0400
Received: by mail-wm0-f66.google.com with SMTP id f4so9672446wmh.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Sep 2017 10:29:35 -0700 (PDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com. [74.125.82.49])
        by smtp.gmail.com with ESMTPSA id t23sm6266565edb.33.2017.09.26.10.29.33
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Sep 2017 10:29:33 -0700 (PDT)
Received: by mail-wm0-f49.google.com with SMTP id b195so10259982wmb.5
        for <linux-wireless@vger.kernel.org>; Tue, 26 Sep 2017 10:29:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1506412757.3276.63.camel@intel.com>
References: <20170915051148.2566-1-gavinli@thegavinli.com> <1506412757.3276.63.camel@intel.com>
From: Gavin Li <gavinli@thegavinli.com>
Date: Tue, 26 Sep 2017 10:29:32 -0700
Message-ID: <CA+GxvY5ff6uFoYO=xis_gb5Zws+MWL-hG4uvupYrx13JXn78bw@mail.gmail.com> (sfid-20170926_193439_584521_88E824FE)
Subject: Re: [PATCH v2] iwlwifi: mvm: allow monitor mode capture in STA mode
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: linuxwifi <linuxwifi@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "git@thegavinli.com" <git@thegavinli.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luciano,

Thanks for the update. I was hoping that it would be supported since I
remember that iwldvm had no problem with it in the past.

Best,
Gavin

On Tue, Sep 26, 2017 at 12:59 AM, Coelho, Luciano
<luciano.coelho@intel.com> wrote:
> Hi Gavin,
>
> On Thu, 2017-09-14 at 22:11 -0700, gavinli@thegavinli.com wrote:
>> From: Gavin Li <git@thegavinli.com>
>>
>> Open up the filter if there is a monitor interface configured; this
>> allows all packets on the channel to be captured even if the device is
>> in STA mode and associated to a BSS.
>>
>> Signed-off-by: Gavin Li <git@thegavinli.com>
>> ---
>
> Sorry for the delay in responding, we were discussing this patch
> internally.
>
> Unfortunately this is not something that our firmware officially
> supports, so we cannot allow it in the driver.  The firmware doesn't
> *block* this from working, but there are no guarantees that it will work
> and that there will not be any side-effects.
>
> If this works for you, feel free to use it (that's one of the beauties
> of open source), but I won't apply it in the mainline driver.
>
>
> --
> Cheers,
> Luca.
