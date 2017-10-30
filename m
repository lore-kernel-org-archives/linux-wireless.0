Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752495AbdJ3Kuu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 06:50:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/3] rsi: sdio: add WOWLAN support for S3 suspend state
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1509103557-6215-2-git-send-email-amitkarwar@gmail.com>
References: <1509103557-6215-2-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Message-Id: <20171030105050.556356028C@smtp.codeaurora.org> (sfid-20171030_115057_104842_73156BC9)
Date: Mon, 30 Oct 2017 10:50:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Karun Eagalapati <karun256@gmail.com>
> 
> WoWLAN is supported in RS9113 device through GPIO pin2.
> wowlan config frame is internally sent to firmware in mac80211
> suspend handler. Also beacon miss threshold and keep-alive time
> values are increased to avoid un-necessary disconnection with AP.
> 
> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

3 patches applied to wireless-drivers-next.git, thanks.

f3ac4e7394a1 rsi: sdio: add WOWLAN support for S3 suspend state
b6c8d06c8a64 rsi: sdio: Add WOWLAN support for S4 hibernate state
063848c3e155 rsi: sdio: Add WOWLAN support for S5 shutdown state

-- 
https://patchwork.kernel.org/patch/10029671/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
