Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:41531 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754974AbeARLVA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 06:21:00 -0500
Received: by mail-it0-f47.google.com with SMTP id b77so13097914itd.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 03:21:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMNDV2=GqLDnxJfk=0+WC25jK-G=SYZL7PAEMZsUT4W5SAEzzg@mail.gmail.com>
References: <CAMNDV2kK33fWYVNNAO8=ZqgxyPdXxTdOrxdQnW6ORMFM1hkrxQ@mail.gmail.com>
 <CANUX_P3Vij4AeiWuOyi5XFiiAF5nqQERR8tDyrRoKZMLFmKoQw@mail.gmail.com> <CAMNDV2=GqLDnxJfk=0+WC25jK-G=SYZL7PAEMZsUT4W5SAEzzg@mail.gmail.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 18 Jan 2018 13:20:59 +0200
Message-ID: <CANUX_P2TtnTV=4A7-v9vMVpu-Hy=Sc1esGaw1iz4rNdvZrHDCg@mail.gmail.com> (sfid-20180118_122105_490712_92DE5C00)
Subject: Re: A few questions about iwlwifi and its rate control mechanism
To: Tambet Arak <tambet.arak@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 18, 2018 at 12:54 PM, Tambet Arak <tambet.arak@gmail.com> wrote:
> I see. I might try playing around with hacking iwl-agn-rs, in that case.
>
>> What do you mean by 'drop'. Disassociated? Or associated but no traffic?
>> Association state can be checked with iw <iface> link
>
> Sorry, that was ambiguous. I meant that the rate is decreased to e.g. MCS3-5.
>

Oh - that can happen because of lower quality radio conditions.
