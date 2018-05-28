Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932523AbeE1P6t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 11:58:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Revert "rt2800: use TXOP_BACKOFF for probe frames"
References: <1527506706-6488-1-git-send-email-sgruszka@redhat.com>
Date: Mon, 28 May 2018 18:58:45 +0300
In-Reply-To: <1527506706-6488-1-git-send-email-sgruszka@redhat.com> (Stanislaw
        Gruszka's message of "Mon, 28 May 2018 13:25:06 +0200")
Message-ID: <87bmczkc0a.fsf@purkki.adurom.net> (sfid-20180528_180030_987784_138EB2D4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> This reverts commit fb47ada8dc3c30c8e7b415da155742b49536c61e.
>
> In some situations when we set TXOP_BACKOFF, the probe frame is
> not sent at all. What it worse then sending probe frame as part
> of AMPDU and can degrade 11n performance to 11g rates.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

I'll try to get to this to final 4.17 still (scheduled for next Sunday),
but no promises if it makes it.

-- 
Kalle Valo
