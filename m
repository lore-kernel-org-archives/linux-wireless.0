Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:38505 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbcJXURG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 16:17:06 -0400
Received: by mail-qk0-f181.google.com with SMTP id v138so7455613qka.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 13:17:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1477286912.4085.1.camel@sipsolutions.net>
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
 <1477286912.4085.1.camel@sipsolutions.net>
From: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjornsmedman@gmail.com>
Date: Mon, 24 Oct 2016 22:17:04 +0200
Message-ID: <CAGp19xdgsoyx9Sa=uas1OEiFoJdzFChmt20++9e7fJK=Z1ujWQ@mail.gmail.com> (sfid-20161024_221710_189489_49FBE8B5)
Subject: Re: Bayesian rate control
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for the pointers.

On Mon, Oct 24, 2016 at 7:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> I'm thinking the best driver for rate control experimentation would
>> be ath9k, right? If so then a TP-Link TL-WA901ND router (apparently
>> based on Qualcomm QCA956x SOC) with OpenWrt, and a TP-Link TL-WDN4800
>> PCIe card (apparently based on Atheros AR9380 with PCI ID 168c:0030)
>> for my desktop sounds like a good combo, no?
>
> Seems reasonable, yes. You wouldn't have VHT, but HT has enough search
> space to keep you busy ;-)

Are there any cards out there that support VHT and use s/w rate
control (Minstrel)? Just in case I run out of search space. :P

BR Bj=C3=B6rn
