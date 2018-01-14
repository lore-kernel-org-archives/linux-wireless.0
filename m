Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36248 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbeANK0k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Jan 2018 05:26:40 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "luca\@coelho.fi" <luca@coelho.fi>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho\, Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH 0/5] iwlwifi: updates intended for v4.16 2017-12-23
References: <20171223092200.30270-1-luca@coelho.fi>
        <871sivs48k.fsf@kamboji.qca.qualcomm.com>
        <1515914548.7436.1.camel@intel.com>
Date: Sun, 14 Jan 2018 12:26:35 +0200
In-Reply-To: <1515914548.7436.1.camel@intel.com> (Emmanuel Grumbach's message
        of "Sun, 14 Jan 2018 07:22:28 +0000")
Message-ID: <87y3l07n38.fsf@codeaurora.org> (sfid-20180114_112645_211584_DF9A5AD7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> On Fri, 2018-01-12 at 13:31 +0200, Kalle Valo wrote:
>> From: Luca Coelho <luciano.coelho@intel.com>
>>
>> > Luca Coelho (1):
>> >   iwlwifi: mvm: check if mac80211_queue is valid in
>> > iwl_mvm_disable_txq
>> > 
>> > Mordechay Goodstein (1):
>> >   iwlwifi: set default timstamp marker cmd
>> > 
>> > Sara Sharon (3):
>> >   iwlwifi: mvm: flip AMSDU addresses only for 9000 family
>> >   iwlwifi: mvm: take RCU lock before dereferencing
>> >   iwlwifi: mvm: move TSO segment to a separate function
>> 
>> Most likely the merge window starts in 9 days so I need to start
>> getting patches ready. As Luca is away should I apply these patches
>> directly to wireless-drivers-next?
>> 
>
> First let me thank you for tracking this. I don't see anything that we
> really need in 4.16 here. Besides Luca's UBSAN warning, all the rest
> is for a new device family which won't be supported in 4.16 anyway.
>
> So I opt to wait for Luca here.

Ok, I'll wait for him then.

-- 
Kalle Valo
