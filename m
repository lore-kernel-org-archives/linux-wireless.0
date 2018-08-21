Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43885 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbeHUMa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 08:30:57 -0400
Received: by mail-lj1-f196.google.com with SMTP id m84-v6so1871447lje.10
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2018 02:11:36 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: remove division by size of sizeof(struct
 ieee80211_wmm_rule)
To: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <20180820073705.9683-1-johannes@sipsolutions.net>
 <20180820102710.GA2760@redhat.com>
 <63f44789-11c3-0549-b8b8-cd3b25c40547@gmail.com>
 <1534842181.25523.1.camel@sipsolutions.net>
 <fbaa39a3-7937-7ecf-040a-c86433baadc7@gmail.com>
 <1534842427.25523.2.camel@sipsolutions.net>
From: =?UTF-8?Q?Grzegorz_Duszy=c5=84ski?= <gfduszynski@gmail.com>
Message-ID: <eed7681f-383c-e3ad-1f56-bdefa4798776@gmail.com> (sfid-20180821_111141_584021_A7F43617)
Date: Tue, 21 Aug 2018 11:11:33 +0200
MIME-Version: 1.0
In-Reply-To: <1534842427.25523.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21.08.2018 11:07, Johannes Berg wrote:
>> I can try to recreate the issue with hwsim, it will take me some time
>> probably as I have no prior experience.
> No worries, I'm compiling it now. Do you have a special hostapd
> configuration?
>
> johannes

I think they are pretty standard:

Compex wle900vx:
https://pastebin.com/pkThTvWH

Killer 1535 - didn't have a chance to finish this one
https://pastebin.com/eJ3t36ra
