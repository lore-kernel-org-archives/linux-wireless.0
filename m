Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:11222 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbCEN5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 08:57:19 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Increase AST table SKID length limit
References: <1423841776-16288-1-git-send-email-sjegadee@qti.qualcomm.com>
Date: Thu, 5 Mar 2015 15:57:09 +0200
In-Reply-To: <1423841776-16288-1-git-send-email-sjegadee@qti.qualcomm.com>
	(SenthilKumar Jegadeesan's message of "Fri, 13 Feb 2015 21:06:16
	+0530")
Message-ID: <87fv9j4kei.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_145722_930822_C86F6FB7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com> writes:

> The current SKID length configuration causes firmware
> to reject peer creation for not able to allocate
> AST entries for peers. This issue is observed when
> least significant 3 bytes are used ramdomly to create
> client MAC addresses.
>
> AST table SKID length configuration is increased to
> maximum value to fix this issue.
>
> Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
