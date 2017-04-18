Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46980 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753293AbdDRRKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 13:10:00 -0400
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
To: Steve deRosier <derosier@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
References: <20170323133048.30062-2-sw@simonwunderlich.de>
 <20170418143654.8AC0A60FAA@smtp.codeaurora.org> <3170657.DNPqgEf8fi@prime>
 <CALLGbRK2d1wZpfLnXu_UDWxVPA9LvejFyEFpzMub56uLH0+DTw@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Julian Calaby <julian.calaby@gmail.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <d4acedac-e28c-4c1c-d112-40557d52f3a2@candelatech.com> (sfid-20170418_191004_249629_4FD0F446)
Date: Tue, 18 Apr 2017 10:09:59 -0700
MIME-Version: 1.0
In-Reply-To: <CALLGbRK2d1wZpfLnXu_UDWxVPA9LvejFyEFpzMub56uLH0+DTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2017 09:33 AM, Steve deRosier wrote:
> Hi,
>
> On Tue, Apr 18, 2017 at 7:50 AM, Simon Wunderlich <sw@simonwunderlich.de <mailto:sw@simonwunderlich.de>> wrote:
>
>     Hi,
>
>     On Tuesday, April 18, 2017 2:36:54 PM CEST Kalle Valo wrote:
>     > Simon Wunderlich <sw@simonwunderlich.de <mailto:sw@simonwunderlich.de>> wrote:
>     > > From: Ben Greear <greearb@candelatech.com <mailto:greearb@candelatech.com>>
>     > >
>     > > Many chips support channels in licensed bands. Add support for those,
>     > > along with a corresponding kernel config option to disable them by
>
> ...
>
>     > I am not sure that we should support unlicensed bands in Linux and hence
>     > hesitant to apply these. My view is that due to regulatory restrictions we
>     > should not make it too easy to use unlicensed bands. But I'm open for
>     > discussion, this is a challenging area and my knowledge here is limited.
>
> ...
>
>
>     In my personal view, we have quite a few obstacles which I consider "enough",
>     but would be interesting to hear others opinions ...
>
>
> I'll throw in my 2-cents. This patch is treading on very dangerous ground. I can't speak to other regulatory environments, but at least the FCC is cracking down
> on even the possibility that anyone can operate a WiFi device outside the regulatory bounds.

These patches make it slightly easier to use the licensed bands, but no one
can accidentally use them due to the regdb and other constaints in these
patches.

So, I don't think these patches offer any fundamental new vulnerability
that should concern the FCC.

After all, someone who really wants to do evil can find and apply the patches
without undue effort, and it could easily be that those applying the patches would
then make it even easier to abuse the new channels due to laziness or poor coding
choices.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
