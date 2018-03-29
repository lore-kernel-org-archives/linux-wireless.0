Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57600 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeC2HUK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 03:20:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org,
        "Zamir\, Roee" <roee.zamir@intel.com>
Subject: Re: [PATCH 07/14] iwlwifi: mvm: add support for oce
References: <20180328141157.5427-1-luca@coelho.fi>
        <20180328142533.9017-1-luca@coelho.fi>
        <87k1twmas7.fsf@kamboji.qca.qualcomm.com>
        <1522266284.3786.288.camel@intel.com>
Date: Thu, 29 Mar 2018 10:20:02 +0300
In-Reply-To: <1522266284.3786.288.camel@intel.com> (Luciano Coelho's message
        of "Wed, 28 Mar 2018 22:44:44 +0300")
Message-ID: <87zi2rl55p.fsf@kamboji.qca.qualcomm.com> (sfid-20180329_092025_872455_974398BC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luciano.coelho@intel.com> writes:

> On Wed, 2018-03-28 at 19:20 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > From: "Zamir, Roee" <roee.zamir@intel.com>
>> > 
>> > Get capabilities from the fw, expose them with nl80211, and enable
>> > them
>> > in UMAC scan if the relevant nl80211 flags are set by the
>> > userspace.
>> > 
>> > Signed-off-by: Roee Zamir <roee.zamir@intel.com>
>> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> 
>> OCE is?
>
> OCE is Optimized Connectivity Experience.  It's WFA's version of
> 802.11ai (FILS).  I'll clarify in the commit message.

Great, thanks. And thanks for improving the other commit logs as well,
much more understandable now.

-- 
Kalle Valo
