Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbeF0Pyj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 11:54:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/6] qtnfmac: implement net_device_ops callback to set MAC
 address
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180531091102.28666-2-sergey.matyukevich.os@quantenna.com>
References: <20180531091102.28666-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Message-Id: <20180627155439.35FE96071C@smtp.codeaurora.org> (sfid-20180627_175443_207042_66F79849)
Date: Wed, 27 Jun 2018 15:54:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> Implement net_device_ops::ndo_set_mac_address callback to allow for
> setting interface MAC address. Implementation is done through existing
> CHANGE_INTF firmware command. All validation is to be done by firmware.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

2 patches applied to wireless-drivers-next.git, thanks.

ed9f34bb9d33 qtnfmac: implement net_device_ops callback to set MAC address
6fbef9540af0 qtnfmac: enable source MAC address randomization support

-- 
https://patchwork.kernel.org/patch/10440557/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
