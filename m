Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55805 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbbCPGVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 02:21:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 1/3] wil6210: NAPI completion refactor
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1426428024-4538-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<2054086.3egRf2SmyA@lx-wigig-72>
Date: Mon, 16 Mar 2015 08:20:57 +0200
In-Reply-To: <2054086.3egRf2SmyA@lx-wigig-72> (Vladimir Kondratiev's message
	of "Sun, 15 Mar 2015 16:03:23 +0200")
Message-ID: <87pp89pinq.fsf@kamboji.qca.qualcomm.com> (sfid-20150316_072111_796849_45A79B35)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> On Sunday, March 15, 2015 04:00:15 PM Vladimir Kondratiev wrote:
>> t is expected that driver completes NAPI when less than
>> full budget is consumed.
>> 
>> Fulfill this requirement.
>> 
>> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
>> 
> Please ignore, old patch, sent by mistake.

Ok, I dropped the three old patches from my queue.

-- 
Kalle Valo
