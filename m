Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33924 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753200AbdESB4b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 21:56:31 -0400
Date: Thu, 18 May 2017 20:56:26 -0500
From: Rob Herring <robh@kernel.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: kvalo@codeaurora.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] dt-binding: net: wireless: fix node name in the
 BCM43xx example
Message-ID: <20170519015626.wsbbbmmaaygjy4yv@rob-hp-laptop> (sfid-20170519_035642_111470_B1755168)
References: <20170515201356.26384-1-martin.blumenstingl@googlemail.com>
 <20170515201356.26384-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170515201356.26384-2-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 15, 2017 at 10:13:56PM +0200, Martin Blumenstingl wrote:
> The example in the BCM43xx documentation uses "brcmf" as node name.
> However, wireless devices should be named "wifi" instead. Fix this to
> make sure that .dts authors can simply use the documentation as
> reference (or simply copy the node from the documentation and then
> adjust only the board specific bits).
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied.

Rob
