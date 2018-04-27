Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45146 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753079AbeD0LXR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 07:23:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: use WMI to set RSN capabilities
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180412154159.13934-1-alfonso.sanchez-beato@canonical.com>
References: <20180412154159.13934-1-alfonso.sanchez-beato@canonical.com>
To: =?utf-8?q?Alfonso_S=C3=A1nchez-Beato?=
        <alfonso.sanchez-beato@canonical.com>
Cc: kvalo@qca.qualcomm.com, ath6kl@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        alfonso.sanchez-beato@canonical.com,
        Steve deRosier <derosier@gmail.com>
Message-Id: <20180427112317.61C9D60452@smtp.codeaurora.org> (sfid-20180427_132322_019404_69DC826C)
Date: Fri, 27 Apr 2018 11:23:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alfonso Sánchez-Beato wrote:

> This fixes AP mode when the ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE flag
> is not present in the FW. The id of some WMI commands is also fixed
> (there was an error in the enum order), and a function to set RSN caps
> is added.
> 
> Signed-off-by: Alfonso Sánchez-Beato <alfonso.sanchez-beato@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Steve, what do you think of this?

-- 
https://patchwork.kernel.org/patch/10338903/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
