Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:38519 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752303AbdLLUxY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 15:53:24 -0500
Date: Tue, 12 Dec 2017 14:53:22 -0600
From: Rob Herring <robh@kernel.org>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        ext.waldemar.rymarkiewicz@tieto.com, kvalo@codeaurora.org
Subject: Re: [PATCH v2 1/2] dt: bindings: add new dt entry for ath10k
 calibration variant
Message-ID: <20171212205322.xwswit2myivd7o6h@rob-hp-laptop> (sfid-20171212_215328_433509_255F4335)
References: <20171208103742.3181-1-sven.eckelmann@openmesh.com>
 <20171208103742.3181-2-sven.eckelmann@openmesh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171208103742.3181-2-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 08, 2017 at 11:37:41AM +0100, Sven Eckelmann wrote:
> The bus + bmi-chip-id + bmi-board-id is not enough to identify the correct
> board data file on QCA4019 based devices. Multiple different boards share
> the same values. Only the original reference designs can currently be
> identified and loaded from the board-2.bin. But these will not result in
> the correct calibration data when combined with the pre-calibration data
> from the device.
> 
> An additional "variant" information has to be provided (via SMBIOS or DT)
> to select the correct board data for a design which was modified by an ODM.
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>                  
