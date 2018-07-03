Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:18624
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753049AbeGCUkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 16:40:25 -0400
Subject: Re: [PATCH] mac80211: don't put null-data frames on the normal TXQ
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180703124725.30917-1-johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <e9813f60-5cf5-a4bf-5906-623282319991@bowerswilkins.com> (sfid-20180703_224041_754627_93E3AE1D)
Date: Tue, 3 Jul 2018 13:40:08 -0700
MIME-Version: 1.0
In-Reply-To: <20180703124725.30917-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/03/2018 05:47 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Since (QoS) NDP frames shouldn't be put into aggregation nor are
> assigned real sequence numbers, etc. it's better to treat them as
> non-data packets and not put them on the normal TXQs, for example
> when building A-MPDUs they need to be treated specially,
To be treated specially at which layer, mac80211 or drivers?
Are you seeing any issues other than complexity of handling NDP or is it 
just improvement?

Thanks,
Peter
