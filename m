Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:35116 "EHLO
	mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbcFTXyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 19:54:17 -0400
Received: by mail-it0-f48.google.com with SMTP id g127so5752522ith.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2016 16:54:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <576854E5.5030206@candelatech.com>
References: <300e3070916441609ff73ea8e06ddb77@euamsexm01a.eu.qualcomm.com> <576854E5.5030206@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 21 Jun 2016 09:53:56 +1000
Message-ID: <CAGRGNgWOScCrLPyqRNus2319BPOehv3awQChoHw=RRMcSDUqzQ@mail.gmail.com> (sfid-20160621_015447_404889_E13AECEA)
Subject: Re: ath9k: Support 4.9Ghz channels on AR9580 adapter.
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Tue, Jun 21, 2016 at 6:41 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 06/20/2016 01:34 PM, Kalle Valo wrote:
>>
>> Ben Greear <greearb@candelatech.com> wrote:
>>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> NOTE:  These channels must not be used in most regulatory
>>> domains unless you have a license from the FCC or similar!
>>>
>>> A proper regulatory database is also required to actually use
>>> these channels.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>
>>
>> I feel that the license is a problem and this doesn't belong to the
>> kernel.
>> The patch has been dropped.
>
>
> It's not a lot different from having to be in normal FCC regulations
> w/regard to
> DFS channels, tx power, and such, but maybe having driver support is
> considered to make it
> too easy for users to hack around restrictions?

Maybe hide this behind CFG80211_CERTIFICATION_ONUS or equivalent?
(Maybe a new symbol CFG80211_LICENSE_REQUIRED with big scary
feds-will-come-knocking warnings in the help text?)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
