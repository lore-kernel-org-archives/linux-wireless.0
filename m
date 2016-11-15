Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45663 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbcKOPIE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 10:08:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] ath10k: use the right length of "background"
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161029111737.19034-1-nicolas.iooss_linux@m4x.org>
References: <20161029111737.19034-1-nicolas.iooss_linux@m4x.org>
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
CC: <ath10k@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Nicolas Iooss" <nicolas.iooss_linux@m4x.org>
Message-ID: <67898e02d2c1489b84cd0c85517445dc@euamsexm01a.eu.qualcomm.com> (sfid-20161115_160829_183587_40C7E14F)
Date: Tue, 15 Nov 2016 16:07:56 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicolas Iooss <nicolas.iooss_linux@m4x.org> wrote:
> The word "background" contains 10 characters so the third argument of
> strncmp() need to be 10 in order to match this prefix correctly.
> 
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
> Fixes: 855aed1220d2 ("ath10k: add spectral scan feature")

Patch applied to ath-next branch of ath.git, thanks.

31b239824ece ath10k: use the right length of "background"

-- 
https://patchwork.kernel.org/patch/9403561/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
