Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9711 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaB0InL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 03:43:11 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k:  add vdev-id, return code to error codes
References: <1392318562-32440-1-git-send-email-greearb@candelatech.com>
	<87bnya6xey.fsf@kamboji.qca.qualcomm.com>
	<530E325E.4060503@candelatech.com>
Date: Thu, 27 Feb 2014 10:43:05 +0200
In-Reply-To: <530E325E.4060503@candelatech.com> (Ben Greear's message of "Wed,
	26 Feb 2014 10:28:46 -0800")
Message-ID: <871typj692.fsf@kamboji.qca.qualcomm.com> (sfid-20140227_094314_743059_BE4A92EF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 02/13/2014 10:06 PM, Kalle Valo wrote:
>> greearb@candelatech.com writes:
>> 
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> When using multiple vdevs (stations, aps, etc), it is
>>> nice to be able to associate log messages with specific
>>> interfaces.  So, add vdev-id to most logging messages.
>>> Add return code as well, where it was missing.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> 
>> I did some changes just to have consistent style for warning messages,
>> see my incremental diff patch below. Let me know if you agree with my
>> changes, the full patch is in ath-next-test branch.
>
> Are you wanting me to send in a revised version of this patch, or
> is it fine as previously posted?

I was planning to send v2 myself, but travelling and vacation got in the
way. I'll try to send it today.

-- 
Kalle Valo
