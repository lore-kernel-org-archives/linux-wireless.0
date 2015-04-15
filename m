Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:15932 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbbDOMmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 08:42:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@codeaurora.org>
CC: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Peter Oh <poh@qca.qualcomm.com>, <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath: use PRI value given by spec for fixed PRI
References: <1427475590-2198-1-git-send-email-poh@qca.qualcomm.com>
	<55191D89.2000300@neratec.com> <55198EA4.1010101@codeaurora.org>
	<551BC2B1.3030002@neratec.com> <551C5C51.8010109@codeaurora.org>
Date: Wed, 15 Apr 2015 15:41:58 +0300
In-Reply-To: <551C5C51.8010109@codeaurora.org> (Peter Oh's message of "Wed, 01
	Apr 2015 14:00:01 -0700")
Message-ID: <87fv817ecp.fsf@kamboji.qca.qualcomm.com> (sfid-20150415_144211_756801_01AD9929)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@codeaurora.org> writes:

>> As for your patch at hand, I tested it for ETSI and it does not
>> change detector performance,
>
> The patch is useful when there are many missing pulses within a burst.
> It happens almost every time when channel loading rate is higher than
> 40%, but around 30% channel loading does not miss pulses that much.
>
>> therefore (please replace 16 with PRI_TOLERANCE in the macro)
>
> I'll do.
>
>> Acked-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

So what's the conclusion? Should I wait for v2 or is this good to
commit? I didn't quite get Zefir's comment about PRI_TOLERANCE above.

-- 
Kalle Valo
