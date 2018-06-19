Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9.mo173.mail-out.ovh.net ([46.105.72.44]:39585 "EHLO
        9.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755466AbeFSVoS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 17:44:18 -0400
Received: from player792.ha.ovh.net (unknown [10.109.120.21])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 511B8C59F0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 22:25:52 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 19 Jun 2018 22:25:37 +0200
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH V3 0/2] brcmfmac: initial work for adding monitor mode
In-Reply-To: <5B2960FD.9010604@broadcom.com>
References: <20180619154809.25698-1-zajec5@gmail.com>
 <5B2960FD.9010604@broadcom.com>
Message-ID: <779e159dc406dc16b004798756f6ee23@milecki.pl> (sfid-20180619_234423_243978_AC523C41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-19 22:01, Arend van Spriel wrote:
> On 6/19/2018 5:48 PM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> After a bit long discussions in various e-mail threads I'm coming with
>> this simple & small patchset. It isn't complete support for monitor 
>> mode
>> but just a pair of preparing patches that should be clear & well
>> discussed by now to make them acceptable.
>> 
>> The main missing bit is code setting MONITOR_FMT_RADIOTAP which I 
>> expect
>> Arend to handle soon, as he already has a patch using "sta_monitor"
>> iovar for that. Then we have to discuss a flag for marking firmwares
>> which are capable for tagging monitor frames.
>> 
>> While still incomplete, I believe that with my previous patches, we 
>> can
>> agree this is a good direction.
>> 
>> Arend: if you find these 2 patches OK, could you ack them, to make it
>> clear for Kalle if they look OK now (or not yet)? I'd be great if you
>> could sent your "sta_monitor" work on top of this.
> 
> I acked them and I will submit my changes later. Either after these
> are applied or simply indicate the dependency.
> 
> Now as for where we are with this. With what we have here we know
> firmware can monitor packets with and without radiotap. However, we do
> not have an indication whether firmware can transport these monitor
> packets to the host. What I need to look into next is whether the
> 802.11 flag in msgbuf is linked to a particular version of the
> protocol, but we may need to resort to the fwid table.

Being able to detect if firmware tags monitor packets would be great.

Please let us know if you find anything and thanks a lot for looking at
this patchset!
