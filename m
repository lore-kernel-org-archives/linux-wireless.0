Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4975 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753762AbcJZHXo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 03:23:44 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kaufman, Liad" <liad.kaufman@intel.com>
Subject: Re: [PATCH 09/10] iwlwifi: mvm: operate in dqa mode
Date: Wed, 26 Oct 2016 07:23:34 +0000
Message-ID: <87mvhr60ay.fsf@kamboji.qca.qualcomm.com> (sfid-20161026_092348_805355_B7CC97FC)
References: <20161019100755.23874-1-luca@coelho.fi>
        <20161019100755.23874-10-luca@coelho.fi>
        <87eg337h7v.fsf@kamboji.qca.qualcomm.com>
        <1477464284.27792.4.camel@intel.com>
        <87r37360qq.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87r37360qq.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Wed, 26 Oct 2016 10:14:05 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

>> Since we've been working on this for so long and already use the term
>> DQA broadly, we thought it wouldn't be necessary to explain more when
>> we are finally enabling it by default.  But of course I can change that
>> if you prefer.
>
> I guessed I could find more information from the history and I know this
> is obvious to your team, but it's not obvious to everyone. The commit
> log should always answer the questions "Why?" and this isn't answering
> that. For example, I need this information when sending pull requests to
> Dave and I'm sure lots of other people find it useful as well,
> especially when enabling a new feature.
>
> So I'm not asking for a long essay, something like this would be
> adequate:
>
> "Run DQA flows by default, as long as the FW supports it. It's currently
> supported on 1234, 3456 and 7654, maybe more in the future. DQA improves
> latency when X is used or throughput when Y is disabled. On the downside
> it sometimes slows down throughput when using Z but that's still
> accetable as it's so rarely used."

Oh, I forgot that the acronym should be also spelled out in the commit
log.

--=20
Kalle Valo=
