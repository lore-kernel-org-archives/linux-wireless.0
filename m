Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38627 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759944AbbA2B5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:57:53 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/6] ath9k: Add a macro to identify PCOEM chips
References: <1421633598-4488-1-git-send-email-sujith@msujith.org>
	<1421633598-4488-4-git-send-email-sujith@msujith.org>
	<21704.53700.641822.118302@gargle.gargle.HOWL>
	<87oapj85k8.fsf@kamboji.qca.qualcomm.com>
	<21704.54622.181818.695588@gargle.gargle.HOWL>
Date: Wed, 28 Jan 2015 14:59:03 +0200
In-Reply-To: <21704.54622.181818.695588@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Wed, 28 Jan 2015 17:56:06 +0530")
Message-ID: <87fvav83jc.fsf@kamboji.qca.qualcomm.com> (sfid-20150129_025801_230612_B4124B51)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> > Kalle, this is a typo - I'll resend the series.
>> 
>> Ok. I had actually put these into "Not Applicable" by accident and
>> that's why I had missed them.
>
> Ah ok. I thought I had to enable some patchwork filters manually to see
> the pending ath9k patches.

For ath10k there's currently a separate patchwork project (I haven't
bothered to change that yet), but for all other drivers you should see
the patches from this link:

https://patchwork.kernel.org/project/linux-wireless/list/

If the patch is not in the list, it's not commited and there's no clear
reason why it was dropped, the chances are that I did a mistake. Like in
this case and also with one of the mwifiex patch earlier this week. I'll
need to be more careful with the states.

-- 
Kalle Valo
