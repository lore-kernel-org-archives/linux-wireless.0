Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:54837 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbeHOS4x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 14:56:53 -0400
Date: Wed, 15 Aug 2018 10:04:07 -0600
From: Rob Herring <robh@kernel.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, briannorris@chromium.org,
        niklas.cassel@linaro.org, bjorn.andersson@linaro.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 3/6] dt: bindings: add bindings for msa memory region
Message-ID: <20180815160407.GA12553@rob-hp-laptop> (sfid-20180815_180412_242331_4C5FAE60)
References: <20180815092637.11455-1-govinds@codeaurora.org>
 <20180815092637.11455-4-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180815092637.11455-4-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2018 at 02:56:34PM +0530, Govind Singh wrote:
> Add device tree binding documentation details of msa
> memory region for ath10k qmi client for SDM845/APQ8098
> SoC into "qcom,ath10k.txt".
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt        | 6 ++++++
>  1 file changed, 6 insertions(+)

Please add acks/reviewed-bys when posting new versions.

Rob
