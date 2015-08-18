Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33533 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbbHRFs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 01:48:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2015-08-14
References: <1439567676.2072.1.camel@sipsolutions.net>
	<CANUX_P3JoD3iczw=uq_Rk6oe+jZHREr85kVzY04+bUtzuK8yew@mail.gmail.com>
Date: Tue, 18 Aug 2015 08:48:15 +0300
In-Reply-To: <CANUX_P3JoD3iczw=uq_Rk6oe+jZHREr85kVzY04+bUtzuK8yew@mail.gmail.com>
	(Emmanuel Grumbach's message of "Sat, 15 Aug 2015 22:33:31 +0300")
Message-ID: <87si7hcfkw.fsf@kamboji.qca.qualcomm.com> (sfid-20150818_074834_029003_E06C8671)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@gmail.com> writes:

> On Fri, Aug 14, 2015 at 6:54 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> Hi,
>>
>> And, in addition to the fix before, I have a -next pull request. It's
>> actually quite big since I hadn't wanted to send one just before my
>> vacation.
>>
>> Let me know if there are any issues.
>>
>> johannes
>>
>
> I will need these patches in iwlwifi-next for my next pull request.
> Please pull them into your tree when you can (probably after Dave
> pulls them).

I pulled it now, but please send your pull request quickly. If Linus
releases 4.2 on Sunday we are running out of time.

commit 15f6d96ded057b898312b0a088a964d585a779b1
Merge: 94e92a7bff23 8f9c98df9493
Author: Kalle Valo <kvalo@codeaurora.org>
Date:   Tue Aug 18 08:44:22 2015 +0300

    Merge tag 'mac80211-next-for-davem-2015-08-14' mac80211-next.git
    
    iwlwifi needs new mac80211 patches so merge mac80211-next.git to
    wireless-drivers-next.git.


-- 
Kalle Valo
