Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:55926 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbeDCUIT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 16:08:19 -0400
Received: by mail-it0-f44.google.com with SMTP id 142-v6so24968988itl.5
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 13:08:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <97a0d771-ece9-fa27-c6c9-d6599b92cea0@nbd.name>
References: <cover.1522766852.git.lorenzo.bianconi@redhat.com>
 <b38ac7608bc8d7cba2a9b7178bd755fae0fc7c6b.1522766852.git.lorenzo.bianconi@redhat.com>
 <97a0d771-ece9-fa27-c6c9-d6599b92cea0@nbd.name>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Tue, 3 Apr 2018 22:08:18 +0200
Message-ID: <CAJ0CqmW354rHcbBsPgjg6qEtohgb9Vx8+dnB=z9xo=EooW_vPQ@mail.gmail.com> (sfid-20180403_220822_797906_627BCDA8)
Subject: Re: [PATCH] mt76x2: remove unnecessary MT_TX_ALC_CFG_4 configuration
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2018-04-03 16:52, Lorenzo Bianconi wrote:
>> Remove unnecessary MT_TX_ALC_CFG_4 configuration since register value
>> has already set to 0 on 5GHz band
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> If I read the code correctly, I think it makes more sense to remove the
> previous initialization, in order to have the writes to that register
> grouped together.
>
> - Felix

Ack, will do in v2

Regards,
Lorenzo
