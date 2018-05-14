Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57036 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932144AbeENNSr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 09:18:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 01/12] ath10k: Add qmi service for wlan qmi client
References: <1522042736-25618-1-git-send-email-govinds@codeaurora.org>
        <20180511170540.GM2259@tuxbook-pro>
Date: Mon, 14 May 2018 16:18:42 +0300
In-Reply-To: <20180511170540.GM2259@tuxbook-pro> (Bjorn Andersson's message of
        "Fri, 11 May 2018 10:05:40 -0700")
Message-ID: <87tvras7d9.fsf@kamboji.qca.qualcomm.com> (sfid-20180514_151856_636418_03375809)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

>> new file mode 100644
>> index 0000000..5857c0c
>> --- /dev/null
>> +++ b/drivers/net/wireless/ath/ath10k/qmi_svc_v01.c
>> @@ -0,0 +1,2323 @@
>> +/*
>> + * Copyright (c) 2018 The Linux Foundation. All rights reserved.
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software for any
>> + * purpose with or without fee is hereby granted, provided that the above
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
>> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
>> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
>> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
>
> Please use SPDX license header.

As ath10k does not use SPDX yet so for consistency I would like to use
the old style license text still and later switch the whole ath10k to
use SPDX in one go.

-- 
Kalle Valo
