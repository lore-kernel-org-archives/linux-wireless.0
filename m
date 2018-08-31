Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbeHaN7U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 09:59:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: linux-kernel@vger.kernel.org, Igor Stoppa <igor.stoppa@huawei.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/23] wireless: remove unnecessary unlikely()
References: <20180830223429.30051-1-igor.stoppa@huawei.com>
        <20180830223429.30051-11-igor.stoppa@huawei.com>
Date: Fri, 31 Aug 2018 12:52:33 +0300
In-Reply-To: <20180830223429.30051-11-igor.stoppa@huawei.com> (Igor Stoppa's
        message of "Fri, 31 Aug 2018 01:34:16 +0300")
Message-ID: <87va7qdfry.fsf@kamboji.qca.qualcomm.com> (sfid-20180831_115253_233898_F3E1A26D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

Igor Stoppa <igor.stoppa@gmail.com> writes:

> WARN_ON_ONCE() already contains an unlikely(), and the logical or of two of
> them is still unlikely(), so it's not necessary to wrap them into another.
>
> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>

IMHO you could fold patches 10, 11 and 12 into one to avoid having three
patches with duplicate titles. Or alternatively use proper driver
prefixes like "ath10k:", "b43:" and so on.

But how do you want these to be applied? For the wireless patches you
didn't Cc linux-wireless so our patchwork won't see them and hence I
can't take them. So if you want me to take these, please resend and
include linux-wireless.

-- 
Kalle Valo
