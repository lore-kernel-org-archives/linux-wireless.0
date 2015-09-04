Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61742 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680AbbIDMzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 08:55:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: Peter Oh <poh@codeaurora.org>, Peter Oh <poh@qca.qualcomm.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath: use PRI value given by spec for fixed PRI
References: <1427475590-2198-1-git-send-email-poh@qca.qualcomm.com>
	<55191D89.2000300@neratec.com> <55198EA4.1010101@codeaurora.org>
	<551BC2B1.3030002@neratec.com> <55E88BA4.7010009@codeaurora.org>
	<55E978BB.1030009@neratec.com>
Date: Fri, 4 Sep 2015 15:55:40 +0300
In-Reply-To: <55E978BB.1030009@neratec.com> (Zefir Kurtisi's message of "Fri,
	04 Sep 2015 12:55:55 +0200")
Message-ID: <877fo6ibsj.fsf@kamboji.qca.qualcomm.com> (sfid-20150904_145553_850930_A90204D8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:

> On 09/03/2015 08:04 PM, Peter Oh wrote:
>> Hi Zefir,
>> 
>> I believe the patch below is good to be checked in since you've already made
>> change in DFS.
>> Can you confirm it?
>> 
>> [...]
>> 
> Hi Peter,
>
> yes, after adding the chirp detecting feature to ath9k, I did an internal
> certification run with all your patches applied. All good for ETSI (FCC testing
> ongoing), so full ACK for the changes.

I don't have any patch like this in my queue anymore, so please resend
if I need to take something.

-- 
Kalle Valo
