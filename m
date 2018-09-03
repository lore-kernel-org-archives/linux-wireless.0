Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40150 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbeICRIb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 13:08:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, sidhayn@gmail.com
Subject: Re: [PATCH 4.19] mt76x0: fix remove_interface
References: <1535970381-5526-1-git-send-email-sgruszka@redhat.com>
Date: Mon, 03 Sep 2018 15:48:27 +0300
In-Reply-To: <1535970381-5526-1-git-send-email-sgruszka@redhat.com> (Stanislaw
        Gruszka's message of "Mon, 3 Sep 2018 12:26:21 +0200")
Message-ID: <87y3cisq5g.fsf@purkki.adurom.net> (sfid-20180903_144834_773831_772B350C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> We wrongly use wcid_mask instead of vif_mask
>
> Fixes: 95e444098a7b ("mt76x0: main file")
> Reported-and-tested-by: Sid Hayn <sidhayn@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

For bug fixes please always try to describe the bug and symptoms. I can
add it this time. From the other thread I saw that 'ifconfig up' failed
like this:

SIOCSIFFLAGS: No space left on device

But in what cases did that happen? (I assume not always)

-- 
Kalle Valo
