Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:56931 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935691AbeFMPKS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 11:10:18 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        "johannes\@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: RE: [PATCH 0/4] cfg80211/mac80211: Add support to configure and monitor txrate threshold
In-Reply-To: <9fd8762e9d2f4b93b299ab859e389b46@aphydexm01b.ap.qualcomm.com>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org> <87fu1q7uq5.fsf@toke.dk> <9fd8762e9d2f4b93b299ab859e389b46@aphydexm01b.ap.qualcomm.com>
Date: Wed, 13 Jun 2018 17:10:07 +0200
Message-ID: <87a7ry7meo.fsf@toke.dk> (sfid-20180613_171115_454708_4C1C84A0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com> writes:

>> This patchsets introduced new NL command and api to support 
>> configuring txrate threshold for the connected stations and api to 
>> notify userspace application upon crossing the configured txrate threshold.
>> This will be useful for the application which requires station's 
>> current capability change information.
>
> What is the intended use case? Asking mostly out of curiosity :)

> [Tamizh] This is to monitor txrate change for a station. By notifying
> userspace when the txrate for a station goes out of configured
> threshold, It can take steering decisions on the particular station.

Yeah, I got that part. I was curious as to what (userspace) application
you were planning to use this for? I.e., what kind of steering
decisions? :)

-Toke
