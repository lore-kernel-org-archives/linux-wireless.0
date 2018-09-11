Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeIKThb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 15:37:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Martin Kaiser <martin@kaiser.cx>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH] mt76: MT76x0U requires MT76_USB
References: <1536239203-21733-1-git-send-email-martin@kaiser.cx>
Date: Tue, 11 Sep 2018 17:37:49 +0300
In-Reply-To: <1536239203-21733-1-git-send-email-martin@kaiser.cx> (Martin
        Kaiser's message of "Thu, 6 Sep 2018 15:06:43 +0200")
Message-ID: <87worst802.fsf@codeaurora.org> (sfid-20180911_163825_556512_A9803AD9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(please cc linux-wireless on wireless patches)

Martin Kaiser <martin@kaiser.cx> writes:

> If we're building MT76x0U, we must select MT76_USB. Otherwise,
> compilation fails because of undefined references.
>
> MT76x2U already does this correctly, fix it for MT76x0U as well.
>
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>

I believe there's a patch pending to fix this, but due to so many mt76
patches it might take few days before the fix is applied to
wireless-drivers-next.

-- 
Kalle Valo
