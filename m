Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56750 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdDROgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 10:36:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170323133048.30062-2-sw@simonwunderlich.de>
References: <20170323133048.30062-2-sw@simonwunderlich.de>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Ben Greear <greearb@candelatech.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Message-Id: <20170418143654.7C2E460F92@smtp.codeaurora.org> (sfid-20170418_163659_910861_D174535D)
Date: Tue, 18 Apr 2017 14:36:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Many chips support channels in licensed bands. Add support for those,
> along with a corresponding kernel config option to disable them by
> default. Note that these channels are not selectable even if the
> option has been compiled unless the user modifies the regulatory
> database to explicitly enable the corresponding channels.
> 
> NOTE:  These channels must not be used in most regulatory
> domains unless you have a license from the FCC or similar!
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> [Hide this support behind a Kconfig option]
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
> [only use the 20 mhz channels, add 5 ghz, change to 4.9ghz to licensed bands, simplify]
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>

I am not sure that we should support unlicensed bands in Linux and hence
hesitant to apply these. My view is that due to regulatory restrictions we
should not make it too easy to use unlicensed bands. But I'm open for
discussion, this is a challenging area and my knowledge here is limited.

-- 
https://patchwork.kernel.org/patch/9641105/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
