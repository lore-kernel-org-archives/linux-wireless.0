Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44459 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbcJGMRo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 08:17:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v7,
 1/3] Documentation: dt: net: add ath9k wireless device binding
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161002214743.2263-2-martin.blumenstingl@googlemail.com>
References: <20161002214743.2263-2-martin.blumenstingl@googlemail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
        chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
        julian.calaby@gmail.com, bjorn@mork.no, linux@rempel-privat.de,
        nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Message-Id: <20161007121743.E625B61AF8@smtp.codeaurora.org> (sfid-20161007_141749_188253_788D6121)
Date: Fri,  7 Oct 2016 12:17:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:
> Add documentation how devicetree can be used to configure ath9k based
> devices.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Looks good to me but missing the ack from DT maintainers, will wait for
that.

3 patches set to Deferred.

9359805 [v7,1/3] Documentation: dt: net: add ath9k wireless device binding
9359801 [v7,2/3] ath9k: add a helper to get the string representation of ath_bus_type
9359803 [v7,3/3] ath9k: parse the device configuration from an OF node

-- 
https://patchwork.kernel.org/patch/9359805/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
