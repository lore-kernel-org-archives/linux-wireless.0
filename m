Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53188 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbCMO3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 10:29:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH] mwifiex: fix a bug in Rx multiport aggregation logic
References: <1426145920-5288-1-git-send-email-akarwar@marvell.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951B16A0745C@SC-VEXCH1.marvell.com>
Date: Fri, 13 Mar 2015 16:29:14 +0200
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951B16A0745C@SC-VEXCH1.marvell.com>
	(Amitkumar Karwar's message of "Thu, 12 Mar 2015 07:07:49 -0700")
Message-ID: <87k2ylq8cl.fsf@kamboji.qca.qualcomm.com> (sfid-20150313_152929_739558_C90D3222)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

>> -----Original Message-----
>> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
>> Sent: Thursday, March 12, 2015 1:09 PM
>> To: linux-wireless@vger.kernel.org
>> Cc: Cathy Luo; Avinash Patil; Amitkumar Karwar
>> Subject: [PATCH] mwifiex: fix a bug in Rx multiport aggregation logic
>> 
>> From: Cathy Luo <cluo@marvell.com>
>> 
>> It's been observed Rx aggregated packets are always followed by a
>> single Rx packet. This patch improves our logic to add that extra
>> packet in next aggregation.
>> 
>> Signed-off-by: Cathy Luo <cluo@marvell.com>
>> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> ---
>
> Please ignore this patch. This is same as "[PATCH 1/3] mwifiex: fix 
> a bug..." sent separately.

Ok, I dropped this patch.

-- 
Kalle Valo
