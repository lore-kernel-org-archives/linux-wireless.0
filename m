Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:22129 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbdLNP2j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:28:39 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/2] dt: bindings: add new dt entry for ath10k calibration variant
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171208103742.3181-2-sven.eckelmann@openmesh.com>
References: <20171208103742.3181-2-sven.eckelmann@openmesh.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <ext.waldemar.rymarkiewicz@tieto.com>,
        <kvalo@codeaurora.org>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Message-ID: <c17f0a577bcd41569831c4eb556d376e@euamsexm01a.eu.qualcomm.com> (sfid-20171214_162850_789022_7F7F45D7)
Date: Thu, 14 Dec 2017 16:28:24 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> wrote:

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
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

40fb0eab30ba dt: bindings: add new dt entry for ath10k calibration variant
d06f26c5c8a4 ath10k: search DT for qcom,ath10k-calibration-variant

-- 
https://patchwork.kernel.org/patch/10102249/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
