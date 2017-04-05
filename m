Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22398 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdDEHhN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:37:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: cancel coverage class work during stop and restart
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1490961521-32746-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1490961521-32746-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <9e55afd425de43178dd528ad242451a5@euamsexm01a.eu.qualcomm.com> (sfid-20170405_093716_818809_BDADA813)
Date: Wed, 5 Apr 2017 09:37:06 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> It seems set_coverage_class_work is not cancelled anywhere,
> though I could not find a crash/warning  with this existing
> design, its safer to cancel it during stop() and also before
> restarting the hardware.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

d94475c2f95c ath10k: cancel coverage class work during stop and restart

-- 
https://patchwork.kernel.org/patch/9656095/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
