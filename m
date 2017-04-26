Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ethic.jabatus.fr ([109.234.163.66]:60144 "EHLO
        mail.ethic.jabatus.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2997865AbdDZKds (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 06:33:48 -0400
From: Michael Mera <dev@michaelmera.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RESEND] ath10k: fix out of bounds access to local buffer
In-Reply-To: <0a7aa133740b4488a19bd95115831988@euamsexm01a.eu.qualcomm.com>
References: <20170424071157.6979-1-dev@michaelmera.com> <0a7aa133740b4488a19bd95115831988@euamsexm01a.eu.qualcomm.com>
Date: Wed, 26 Apr 2017 19:32:51 +0900
Message-ID: <87a873wjak.fsf@michaelmera.com> (sfid-20170426_123420_050609_43D3E74E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:
> I fixed a checkpatch warning in the pending branch:
>
> drivers/net/wireless/ath/ath10k/debug.c:636: spaces preferred around that '-' (ctx:VxV)

Hum... but then you will have a line longer than 80 characters (81), so
another warning.
I prefered this version since I feel that splitting this line would hurt
readability and on the other hand the expression is clearly delimited
by the spaces around the ',' so I don't think spaces around the operator
add any value (except for compliance with the coding style that is).

Thanks,
Michael Mera
