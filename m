Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42353 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbbL2Sep (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 13:34:45 -0500
Date: Tue, 29 Dec 2015 12:34:40 -0600
From: Rob Herring <robh@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kalle Valo <kvalo@codeaurora.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <pawel.moll@arm.com>, devicetree@vger.kernel.org,
	fengwei.yin@linaro.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: Re: [PATCH 4/4] dt: binding: Add Qualcomm wcn36xx WiFi binding
Message-ID: <20151229183440.GC12450@rob-hp-laptop> (sfid-20151229_193659_235539_E6B3131E)
References: <1451266467-15377-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1451266467-15377-5-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1451266467-15377-5-git-send-email-bjorn.andersson@sonymobile.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 27, 2015 at 05:34:27PM -0800, Bjorn Andersson wrote:
> Add binding representing the Qualcomm wcn3620/60/80 WiFi block.
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  .../bindings/net/wireless/qcom,wcn36xx-wifi.txt    | 76 ++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,wcn36xx-wifi.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,wcn36xx-wifi.txt b/Documentation/devicetree/bindings/net/wireless/qcom,wcn36xx-wifi.txt
> new file mode 100644
> index 000000000000..7b314b9f30af
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,wcn36xx-wifi.txt
> @@ -0,0 +1,76 @@
> +Qualcomm WCN36xx WiFi Binding
> +
> +This binding describes the Qualcomm WCN36xx WiFi hardware. The hardware block
> +is part of the Qualcomm WCNSS core, a WiFi/BT/FM combo chip, found in a variety
> +of Qualcomm platforms.

Are BT/FM functions completely separate? If so, separate bindings are 
okay. If not, then we need to describe the full chip.

Rob
