Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33024 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbbL2TLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 14:11:15 -0500
Received: by mail-pf0-f170.google.com with SMTP id q63so95096296pfb.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Dec 2015 11:11:14 -0800 (PST)
Date: Tue, 29 Dec 2015 13:11:12 -0600
From: Andy Gross <andy.gross@linaro.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kalle Valo <kvalo@codeaurora.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
	fengwei.yin@linaro.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: Re: [PATCH 4/4] dt: binding: Add Qualcomm wcn36xx WiFi binding
Message-ID: <20151229191112.GB27812@hector.attlocal.net> (sfid-20151229_201122_185315_F6ABE7C8)
References: <1451266467-15377-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1451266467-15377-5-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1451266467-15377-5-git-send-email-bjorn.andersson@sonymobile.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 27, 2015 at 05:34:27PM -0800, Bjorn Andersson wrote:
> Add binding representing the Qualcomm wcn3620/60/80 WiFi block.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---

<snip>

> +
> +- qcom,wcnss-mmio:
> +	Usage: required
> +	Value type: <prop-encoed-array>

nit:  encoded

> +	Definition: should specify base address and size of the WiFi related
> +		    registers of WCNSS
> +
> +- qcom,state:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: should specify the tx-enable and tx-ring-empty state
> +		    references
> +

<snip>

Otherwise looks good.

Reviewed-by: Andy Gross <andy.gross@linaro.org>
