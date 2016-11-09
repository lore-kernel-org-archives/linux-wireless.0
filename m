Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52754 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753565AbcKIBPx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 20:15:53 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rsi: New firware loading method for RSI 91X devices
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1477044595-10348-1-git-send-email-prameela.j04cs@gmail.com>
References: <1477044595-10348-1-git-send-email-prameela.j04cs@gmail.com>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20161109011553.18EBC612E8@smtp.codeaurora.org> (sfid-20161109_021639_603320_BD549CD5)
Date: Wed,  9 Nov 2016 01:15:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> wrote:
> RSI deprecated the old firmware loading method and introduced
> new method using soft boot loader for 9113 chipsets.
> Current driver only supports 9113 device model hence firmware
> loading method has been changed.
> 
> In the new method, complete RAM image and flash image are present
> in the flash. Two firmwares present in the device, Boot loader firmware
> and functional firmware. Boot loader firmware is fixed but functional
> firmware can be changed. Before loading the functional firmware, host
> issues commands to check whether existing firmware in the chip and the
> firmware file content to load are same or not. If not, host issues
> commands to load the RAM image and then boot loaded switches to the
> functioanl firmware.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

These two patches are quite big, difficult to review. Smaller changes
would help with that. Will review later.

2 patches set to Deferred.

9388629 [1/2] rsi: New firware loading method for RSI 91X devices
9388627 [2/2] rsi: Device initialization sequence is changed

-- 
https://patchwork.kernel.org/patch/9388629/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
