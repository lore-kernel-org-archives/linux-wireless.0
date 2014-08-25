Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50615 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaHYIWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 04:22:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix wmi service bitmap
References: <1408447352-28688-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 25 Aug 2014 11:22:38 +0300
In-Reply-To: <1408447352-28688-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 19 Aug 2014 13:22:32 +0200")
Message-ID: <87bnr96ks1.fsf@kamboji.qca.qualcomm.com> (sfid-20140825_102256_048231_6AB60982)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Service mapping for main firmware branch was
> incorrectly used for 10.x firmware and vice-versa.
> This caused wmi_services in debugfs to print wrong
> values.
>
> This actually fixes a problem with the previous
> wmi service bitmap patch itself. For some reason
> there was either a conflict that wasn't resolved
> properly or git had a bad day.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied. I just changed the commit log a bit:

    ath10k: fix a conflict bug in wmi service bitmap
    
    Service mapping for main firmware branch was incorrectly used for 10.x firmware
    and vice-versa.  This caused wmi_services in debugfs to print wrong values.
    
    This fixes commit cff990ce7ddd6 ("ath10k: fix wmi service bitmap debug") where
    for some reason there was either a conflict that wasn't resolved properly or
    git had a bad day.
    
    Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>


-- 
Kalle Valo
