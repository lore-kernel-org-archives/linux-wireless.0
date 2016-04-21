Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37614 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbcDUObH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 10:31:07 -0400
Date: Thu, 21 Apr 2016 09:31:02 -0500
From: Rob Herring <robh@kernel.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v7 1/2] dt: bindings: add MARVELL's sd8xxx wireless device
Message-ID: <20160421143102.GA17372@rob-hp-laptop> (sfid-20160421_163112_881087_F2474A45)
References: <1460982143-1419-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460982143-1419-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 18, 2016 at 05:22:22AM -0700, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> Add device tree binding documentation for MARVELL's sd8xxx
> (sd8897 and sd8997) wlan chip.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> Listing changelist for both 1/2 and 2/2 patches
> v3: Don't update adapter->dt_node if mwifiex_plt_dev is NULL
> 
> v4: a)Corrected the 'name' and 'compatible' property names.(Arnd Bergmann and Rob
>     Herring)
>     b)Patch description wraped in 72 columns(Rob Herring)
>     c)Moved DT binding file to bindings/net/wireless/(Rob Herring)
>     d)Renamed "mwifiex,chip-gpio" to "marvell,wakeup-gpios"(Rob Herring/
>     Arnd Bergmann)
>     e)Replaced #ifdef with __maybe_unused(Arnd Bergmann)
> 
> v5: a)Removed wildcards from compatible string(Arnd Bergmann)
>     b)Prepared single patch for all binding changes(Rob Herring)
>     c)Specified our node as a subnode of SDIO controller. With this approach, we
>     don't need to register new platform driver. (Rob herring)
> 
> v6: a)List out the specific property names for marvell,caldata* and size of the data(Rob Herring)
>     b)Use sdio function number for both the unit address and reg(Rob Herring)
> 
> v7: a)Use suggested specific marvell,caldata property name and generic node name(Rob Herring)
> ---
>  .../bindings/net/wireless/marvell-sd8xxx.txt       | 63 ++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt

Acked-by: Rob Herring <robh@kernel.org>
