Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17603 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764039AbdDSOI4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 10:08:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,3/3] ath9k: add noise floor override option
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170323133048.30062-4-sw@simonwunderlich.de>
References: <20170323133048.30062-4-sw@simonwunderlich.de>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: <ath10k@lists.infradead.org>, <ath9k-devel@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Simon Wunderlich <sw@simonwunderlich.de>
Message-ID: <789c82fc5c3b446b8b24c87ec9e45ed5@euamsexm01a.eu.qualcomm.com> (sfid-20170419_160859_849854_309A1066)
Date: Wed, 19 Apr 2017 16:08:47 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> wrote:
> Introduce a debugfs option to manually override the noise floor,
> ignoring the automatically tuned noise floor of the driver/hw.
> 
> In my tests with a AR9580 based module and a tx99 5 MHz interferer,
> I could tune the noisefloor to -95 dBm or above to allow communication
> again. The automatic noise floor calibration sometimes could adapt to
> the situation as well, but not reliably and permanently.
> 
> I would consider this "feature" experimental and interesting for people
> debugging the noise floor calibration or other effects of the hardware.
> 
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>

Patch applied to ath-next branch of ath.git, thanks.

b90189759a7f ath9k: add noise floor override option

-- 
https://patchwork.kernel.org/patch/9641107/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
