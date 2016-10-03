Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45449 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbcJCH0y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 03:26:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8xxxu: Fix big-endian problem reporting mactime
References: <1475178055-16924-1-git-send-email-Jes.Sorensen@redhat.com>
        <1475178055-16924-3-git-send-email-Jes.Sorensen@redhat.com>
Date: Mon, 03 Oct 2016 10:26:50 +0300
In-Reply-To: <1475178055-16924-3-git-send-email-Jes.Sorensen@redhat.com> (Jes
        Sorensen's message of "Thu, 29 Sep 2016 15:40:55 -0400")
Message-ID: <87shsdsxj9.fsf@kamboji.qca.qualcomm.com> (sfid-20161003_092658_268805_2110AFCB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> The full RX descriptor is converted so converting tsfl again would
> return it to it's original endian value.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

I'll add:

Cc: stable@vger.kernel.org # 4.8+

-- 
Kalle Valo
