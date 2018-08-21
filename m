Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43462 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbeHUMZx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 08:25:53 -0400
Received: by mail-lf1-f65.google.com with SMTP id f135-v6so13013023lfg.10
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2018 02:06:33 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: remove division by size of sizeof(struct
 ieee80211_wmm_rule)
To: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <20180820073705.9683-1-johannes@sipsolutions.net>
 <20180820102710.GA2760@redhat.com>
 <63f44789-11c3-0549-b8b8-cd3b25c40547@gmail.com>
 <1534842181.25523.1.camel@sipsolutions.net>
From: =?UTF-8?Q?Grzegorz_Duszy=c5=84ski?= <gfduszynski@gmail.com>
Message-ID: <fbaa39a3-7937-7ecf-040a-c86433baadc7@gmail.com> (sfid-20180821_110636_508798_6F1A0949)
Date: Tue, 21 Aug 2018 11:06:29 +0200
MIME-Version: 1.0
In-Reply-To: <1534842181.25523.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21.08.2018 11:03, Johannes Berg wrote:
> On Tue, 2018-08-21 at 08:23 +0200, Grzegorz Duszyński wrote:
>> I've applied the patch, but it does not seem to help.
>> Spawning second instance of hostapd causes same error as before.
> Ok, it was worth a try.
>
>> I don't follow why this issue would not occur with single NIC.
>> It's not like I am an expert in this field, but those rules should be
>> applied to both interfaces, right?
>> Both interfaces use ath10k, that should imply same code path for setting
>> rules.
> Yeah that's why I thought maybe the copy code was involved ...
>
> I guess we'll need to try to reproduce. Maybe it can be made to happen
> with hwsim too?
>
> johannes

I can try to recreate the issue with hwsim, it will take me some time 
probably as I have no prior experience.
