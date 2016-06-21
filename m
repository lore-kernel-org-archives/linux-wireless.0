Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35593 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbcFUAGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 20:06:22 -0400
Subject: Re: ath9k: Support 4.9Ghz channels on AR9580 adapter.
To: Julian Calaby <julian.calaby@gmail.com>
References: <300e3070916441609ff73ea8e06ddb77@euamsexm01a.eu.qualcomm.com>
 <576854E5.5030206@candelatech.com>
 <CAGRGNgWOScCrLPyqRNus2319BPOehv3awQChoHw=RRMcSDUqzQ@mail.gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5768838D.8000201@candelatech.com> (sfid-20160621_020636_550944_332D9C4B)
Date: Mon, 20 Jun 2016 17:00:13 -0700
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWOScCrLPyqRNus2319BPOehv3awQChoHw=RRMcSDUqzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2016 04:53 PM, Julian Calaby wrote:
> Hi Ben,
>
> On Tue, Jun 21, 2016 at 6:41 AM, Ben Greear <greearb@candelatech.com> wrote:
>> On 06/20/2016 01:34 PM, Kalle Valo wrote:
>>>
>>> Ben Greear <greearb@candelatech.com> wrote:
>>>>
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> NOTE:  These channels must not be used in most regulatory
>>>> domains unless you have a license from the FCC or similar!
>>>>
>>>> A proper regulatory database is also required to actually use
>>>> these channels.
>>>>
>>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>>
>>>
>>> I feel that the license is a problem and this doesn't belong to the
>>> kernel.
>>> The patch has been dropped.
>>
>>
>> It's not a lot different from having to be in normal FCC regulations
>> w/regard to
>> DFS channels, tx power, and such, but maybe having driver support is
>> considered to make it
>> too easy for users to hack around restrictions?
>
> Maybe hide this behind CFG80211_CERTIFICATION_ONUS or equivalent?
> (Maybe a new symbol CFG80211_LICENSE_REQUIRED with big scary
> feds-will-come-knocking warnings in the help text?)

That would be fine with me.  As I said though, there are more patches
than this one needed for full features and interoperability.
The person that sent me the mac80211/wireless patches,
and hostapd for that matter, may be able to put something together for upstream,
but I am not sure if they will have time.

I don't currently feel motivated enough to try to clean it all up and
try to push it upstream myself.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

