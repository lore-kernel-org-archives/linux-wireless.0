Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38267 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbdLSNZY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 08:25:24 -0500
Received: by mail-wm0-f47.google.com with SMTP id 64so3656945wme.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Dec 2017 05:25:24 -0800 (PST)
Date: Tue, 19 Dec 2017 14:25:19 +0100 (CET)
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
Message-ID: <alpine.LNX.2.21.99.1712191424570.17763@localhost.localdomain> (sfid-20171219_142535_542802_AA29EC7C)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain> <20171213152017.GA3554@redhat.com> <alpine.LNX.2.21.99.1712161924030.11214@localhost.localdomain> <20171218152142.GA15414@redhat.com> <20171219122707.GA2672@redhat.com>
 <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain> <20171219125431.GB2672@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much.
I'll let you know. Compiling now.


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
