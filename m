Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59227 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbbDORM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 13:12:57 -0400
Message-ID: <552E9B7C.5080109@codeaurora.org> (sfid-20150415_191300_654291_8EB82109)
Date: Wed, 15 Apr 2015 10:10:20 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	Peter Oh <poh@qca.qualcomm.com>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: Re: [PATCH] ath: use PRI value given by spec for fixed PRI
References: <1427475590-2198-1-git-send-email-poh@qca.qualcomm.com> <55191D89.2000300@neratec.com> <55198EA4.1010101@codeaurora.org> <551BC2B1.3030002@neratec.com> <551C5C51.8010109@codeaurora.org> <87fv817ecp.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fv817ecp.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 04/15/2015 05:41 AM, Kalle Valo wrote:
> Peter Oh <poh@codeaurora.org> writes:
>
>>> As for your patch at hand, I tested it for ETSI and it does not
>>> change detector performance,
>> The patch is useful when there are many missing pulses within a burst.
>> It happens almost every time when channel loading rate is higher than
>> 40%, but around 30% channel loading does not miss pulses that much.
>>
>>> therefore (please replace 16 with PRI_TOLERANCE in the macro)
>> I'll do.
>>
>>> Acked-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> So what's the conclusion? Should I wait for v2 or is this good to
> commit? I didn't quite get Zefir's comment about PRI_TOLERANCE above.
>
Please wait for 2nd patches. I'll prepare the patches that do not void 
this current products certificate.

Regards,
Peter
