Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46861 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936340AbdJQPZy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 11:25:54 -0400
Received: from mail-vk0-f51.google.com ([209.85.213.51])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <jesse.sung@canonical.com>)
        id 1e4Tkf-0003zl-9P
        for linux-wireless@vger.kernel.org; Tue, 17 Oct 2017 15:25:53 +0000
Received: by mail-vk0-f51.google.com with SMTP id j2so1347552vki.4
        for <linux-wireless@vger.kernel.org>; Tue, 17 Oct 2017 08:25:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1508253043.10607.89.camel@sipsolutions.net>
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
 <1508233890.10607.70.camel@sipsolutions.net> <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
 <1508237298.10607.76.camel@sipsolutions.net> <CAH10aOjmMdN2pGP8FDwZQ6BRcu2O5PiGjk+kKb6bAa7nS=ap8g@mail.gmail.com>
 <1508246019.10607.77.camel@sipsolutions.net> <CAH10aOgfNZbhUYfRa7VRPwvzDNTYtmeDYnDEMtq+6HPqbq94hg@mail.gmail.com>
 <CAH10aOizMKboDOW27gvz=YEcRT1_tMj+W6iwJ47n=T=-Q7U14A@mail.gmail.com> <1508253043.10607.89.camel@sipsolutions.net>
From: Jesse Sung <jesse.sung@canonical.com>
Date: Tue, 17 Oct 2017 23:25:51 +0800
Message-ID: <CAH10aOi-0ABTmt4MKe-9MrB77gR4xTj9uNf=jcpFKvr86emcPg@mail.gmail.com> (sfid-20171017_172610_593908_0FB0B0DE)
Subject: Re: Commit 0711d638 breaks mwifiex
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 17, 2017 at 11:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
>> > > https://p.sipsolutions.net/8f9d5917a5cbe4b3.txt
>> > >
>> > > Can you also give that a spin?
>
> Thanks for testing!
>
>> > Issued four reassociate, the network interface is still alive. Also
>> > with this patch it stays with BSSID1 and I don't see any
>> > "Association request to the driver failed" in the process.
>>
>> Correction: I can still see "Association request to the driver
>> failed" and switching between BSSIDs with more reassociates but I
>> think that shouldn't be an issue?
>
> Not sure what you mean by "with more reassociates"?

I mean do more "reassociate" in the wpa_cli. :)

Thanks,
Jesse
