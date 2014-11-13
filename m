Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16338 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbaKMNW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 08:22:26 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 06/10] ath10k: use configured nss instead of max nss.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-6-git-send-email-greearb@candelatech.com>
	<54592F3E.10204@candelatech.com>
Date: Thu, 13 Nov 2014 15:22:12 +0200
In-Reply-To: <54592F3E.10204@candelatech.com> (Ben Greear's message of "Tue,
	04 Nov 2014 11:55:42 -0800")
Message-ID: <87ioijteuz.fsf@kamboji.qca.qualcomm.com> (sfid-20141113_142229_623081_5336319F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 09/23/2014 02:17 PM, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>> 
>> When re-associating a station, the nss was set back to
>> maximum value even if user had configured small number
>> of tx chains.  So, pay attention to user's config in
>> this case as well.
>
> Looks like this (and probably the related patch) did not make
> it upstream yet.
>
> Is someone waiting for more changes from me or did this just
> get lost?

Sorry, it fell through the cracks. I'll take a look at them soon.

-- 
Kalle Valo
