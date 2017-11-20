Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:46002 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752980AbdKTVe0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 16:34:26 -0500
Date: Mon, 20 Nov 2017 15:34:23 -0600
From: Rob Herring <robh@kernel.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v7 1/3] dt-bindings: net: add mt76 wireless device binding
Message-ID: <20171120213423.kzjtoq6ggrylomh5@rob-hp-laptop> (sfid-20171120_223429_966008_19886CED)
References: <20171120193549.80831-1-nbd@nbd.name>
 <20171120193549.80831-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171120193549.80831-2-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 20, 2017 at 08:35:47PM +0100, Felix Fietkau wrote:
> Add documentation describing how device tree can be used to configure
> wireless chips supported by the mt76 driver.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  .../bindings/net/wireless/mediatek,mt76.txt        | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt

Acked-by: Rob Herring <robh@kernel.org>
