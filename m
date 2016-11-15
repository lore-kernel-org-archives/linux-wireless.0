Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56335 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752988AbcKOO5A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 09:57:00 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v8,
 1/3] Documentation: dt: net: add ath9k wireless device binding
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161016205907.19927-2-martin.blumenstingl@googlemail.com>
References: <20161016205907.19927-2-martin.blumenstingl@googlemail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC: <ath9k-devel@lists.ath9k.org>, <devicetree@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <robh+dt@kernel.org>, <mcgrof@do-not-panic.com>,
        <mark.rutland@arm.com>, <kvalo@codeaurora.org>,
        <chunkeey@googlemail.com>, <arend.vanspriel@broadcom.com>,
        <julian.calaby@gmail.com>, <bjorn@mork.no>,
        <linux@rempel-privat.de>, <nbd@nbd.name>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Message-ID: <cfd35a091551410cb69f2444109d3193@euamsexm01a.eu.qualcomm.com> (sfid-20161115_155705_794591_63C5BEC6)
Date: Tue, 15 Nov 2016 15:56:47 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:
> Add documentation how devicetree can be used to configure ath9k based
> devices.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Acked-by: Rob Herring <robh@kernel.org>

3 patches applied to ath-next branch of ath.git, thanks.

fc383ffdb91a Documentation: dt: net: add ath9k wireless device binding
b40ded2ad75c ath9k: add a helper to get the string representation of ath_bus_type
138b41253d9c ath9k: parse the device configuration from an OF node

-- 
https://patchwork.kernel.org/patch/9378317/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
