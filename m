Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55238 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755735AbeDXF3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 01:29:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com, christian.koenig@amd.com,
        arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, hdegoede@redhat.com
Subject: Re: [PATCH 9/9] ath10k: re-enable the firmware fallback mechanism for testmode
References: <20180423201205.20533-1-andresx7@gmail.com>
        <20180423201205.20533-10-andresx7@gmail.com>
Date: Tue, 24 Apr 2018 08:29:38 +0300
In-Reply-To: <20180423201205.20533-10-andresx7@gmail.com> (Andres Rodriguez's
        message of "Mon, 23 Apr 2018 16:12:05 -0400")
Message-ID: <87fu3lcgu5.fsf@kamboji.qca.qualcomm.com> (sfid-20180424_073049_366047_7C2356E0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andres Rodriguez <andresx7@gmail.com> writes:

> The ath10k testmode uses request_firmware_direct() in order to avoid
> producing firmware load warnings. Disabling the fallback mechanism was a
> side effect of disabling warnings.
>
> We now have a new API that allows us to avoid warnings while keeping the
> fallback mechanism enabled. So use that instead.
>
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>

Thanks!

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
