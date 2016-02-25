Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41342 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638AbcBYTvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 14:51:22 -0500
Message-ID: <56CF5AE3.70302@codeaurora.org> (sfid-20160225_205126_318586_AD177A2A)
Date: Thu, 25 Feb 2016 11:49:55 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	"Oh, Peter" <poh@qca.qualcomm.com>
Subject: Re: [PATCH v3] ath10k: set MAC timestamp in management Rx frame
References: <4c705dc7a2c0aa857da4e6eaf6e8ed47c354b9ea.1456351768.git.poh@qca.qualcomm.com> <87k2lsd9zv.fsf@kamboji.qca.qualcomm.com> <56CF4DA3.8030803@codeaurora.org> <12890529.ZzYcJYx9dF@sven-edge>
In-Reply-To: <12890529.ZzYcJYx9dF@sven-edge>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you!

On 02/25/2016 11:32 AM, Sven Eckelmann wrote:
> On Thursday 25 February 2016 10:53:23 Peter Oh wrote:
>>> I see new warnings:
>>>
>>> drivers/net/wireless/ath/ath10k/wmi.c:2199:16: warning: restricted
> __le32
>>> degrades to integer
>>> drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: restricted
> __le32
>>> degrades to integer
>>> drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: cast to
> restricted
>>> __le32
>>> drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: restricted
> __le32
>>> degrades to integer
>> Do I have a way to run this check before submitting a patch such as
>> checkpatch.pl?
> Looks like sparse with -D__CHECK_ENDIAN__ [1]
>
> You may also try smatch [2]
>
> Kind regards,
> 	Sven
>
> [1] https://www.kernel.org/doc/Documentation/sparse.txt
> [2] http://smatch.sourceforge.net/

