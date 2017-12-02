Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:16543 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdLBON1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 09:13:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: dfs: use swap macro in ath9k_check_chirping
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171103201425.GA26452@embeddedor.com>
References: <20171103201425.GA26452@embeddedor.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
CC: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <d346ef228c8e4bb68a262c36abe5552e@euamsexm01a.eu.qualcomm.com> (sfid-20171202_151352_050367_F8151E2D)
Date: Sat, 2 Dec 2017 15:13:18 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:

> Make use of the swap macro and remove unnecessary variable temp.
> This makes the code easier to read and maintain.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

626ab6707abe ath9k: dfs: use swap macro in ath9k_check_chirping

-- 
https://patchwork.kernel.org/patch/10041197/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
