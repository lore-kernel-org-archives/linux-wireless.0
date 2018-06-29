Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 3.mo68.mail-out.ovh.net ([46.105.58.60]:34741 "EHLO
        3.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753194AbeF2KqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 06:46:20 -0400
Received: from player761.ha.ovh.net (unknown [10.109.120.40])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 79747E6702
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 09:06:57 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 29 Jun 2018 09:06:44 +0200
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH V4 2/3] brcmfmac: detect firmware support for radiotap
 monitor frames
In-Reply-To: <87wouif51j.fsf@codeaurora.org>
References: <20180624194437.28766-1-zajec5@gmail.com>
 <20180624194437.28766-2-zajec5@gmail.com> <87wouif51j.fsf@codeaurora.org>
Message-ID: <a7f592acd7664f619d3f37b77d14bafe@milecki.pl> (sfid-20180629_124624_606316_D9B26261)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-29 09:03, Kalle Valo wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
> 
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> Depending on used build-time options some firmwares may already 
>> include
>> radiotap header in passed monitor frames. Add a new feature flag to
>> store info about it. It's needed for proper handling of received 
>> frames
>> before passing them up.
>> 
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> BTW, we now have Co-Developed-by:
> 
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by
> 
> But no need to change this patch, just a tip for the future. I assume
> this patchset is good to go and will apply it soon.

Nice to know, thanks!
