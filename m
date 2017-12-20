Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:40199 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755346AbdLTRuA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 12:50:00 -0500
Received: by mail-wr0-f179.google.com with SMTP id q9so23009278wre.7
        for <linux-wireless@vger.kernel.org>; Wed, 20 Dec 2017 09:49:59 -0800 (PST)
Date: Wed, 20 Dec 2017 18:49:56 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
In-Reply-To: <20171219125431.GB2672@redhat.com>
Message-ID: <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain> (sfid-20171220_185003_962051_93987B5B)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain> <20171213152017.GA3554@redhat.com> <alpine.LNX.2.21.99.1712161924030.11214@localhost.localdomain> <20171218152142.GA15414@redhat.com> <20171219122707.GA2672@redhat.com>
 <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain> <20171219125431.GB2672@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.
First of all, thank you for your patience and work.
Sorry if I am slow in testing, I am in a little bit of a complicated situation, and this is one of the reasons for why I am slow.
With the two patches you sent me (thanks!), and removing the mmio workaround patch, I was not able to reproduce the errors. I plan to send you a precise response as soon as I am able to.
thank you

On Tue, 19 Dec 2017, Stanislaw Gruszka wrote:

> Date: Tue, 19 Dec 2017 13:54:32
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> To: Enrico Mioso <mrkiko.rs@gmail.com>
> Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
>     Daniel Golle <daniel@makrotopia.org>, Arnd Bergmann <arnd@arndb.de>,
>     John Crispin <john@phrozen.org>, nbd@nbd.name
> Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
>     frame due to full tx queue...?
> 
> On Tue, Dec 19, 2017 at 01:43:11PM +0100, Enrico Mioso wrote:
>> I am going to test this on a LEDE build.
>> Should I leave the mmio workaround patch applied as per OpenWRT default, or should I leave it off ?
>> I'll leave it off by default.
>
> Please remove it. If things would work then retest with it and see if
> if things still work.
>
> Thanks
> Stanislaw
>
