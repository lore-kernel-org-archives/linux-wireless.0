Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60240 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbdBGOqu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 09:46:50 -0500
Message-ID: <5899DDD7.7000605@candelatech.com> (sfid-20170207_154723_362115_D4672AA2)
Date: Tue, 07 Feb 2017 06:46:47 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        Adrian Chadd <adrian@freebsd.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        =?UTF-8?B?QW1hZGV1c3ogU8WCYXdpxYRza2k=?=
        <amadeusz.slawinski@tieto.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: remove ath10k_vif_to_arvif()
References: <1486030773-30600-1-git-send-email-amadeusz.slawinski@tieto.com> <CAJ-VmonrHpS3MArM9ohHgLvb6xspP_gnVVeJWA9F-pjUpJ+LZA@mail.gmail.com> <87y3xi4b28.fsf@qca.qualcomm.com>
In-Reply-To: <87y3xi4b28.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/07/2017 01:14 AM, Valo, Kalle wrote:
> Adrian Chadd <adrian@freebsd.org> writes:
>
>> Removing this method makes the diff to FreeBSD larger, as "vif" in
>> FreeBSD is a different pointer.
>>
>> (Yes, I have ath10k on freebsd working and I'd like to find a way to
>> reduce the diff moving forward.)
>
> I don't like this "(void *) vif->drv_priv" style that much either but
> apparently it's commonly used in Linux wireless code and already parts
> of ath10k. So this patch just unifies the coding style.

Surely the code compiles to the same thing, so why add a patch that
makes it more difficult for Adrian and makes the code no easier to read
for the rest of us?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
