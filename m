Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:51078 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbdKTQZr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 11:25:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: fix iris child-node lookup
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171111170532.6110-1-johan@kernel.org>
References: <20171111170532.6110-1-johan@kernel.org>
To: Johan Hovold <johan@kernel.org>
CC: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>
Message-ID: <99d62be5fdff4f7a93470dbc289c5cdb@eusanexr01a.eu.qualcomm.com> (sfid-20171120_172607_401222_008C1D61)
Date: Mon, 20 Nov 2017 08:25:41 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johan Hovold <johan@kernel.org> wrote:

> Fix child-node lookup during probe, which ended up searching the whole
> device tree depth-first starting at the parent rather than just matching
> on its children.
> 
> To make things worse, the parent mmio node was also prematurely freed.
> 
> Fixes: fd52bdae9ab0 ("wcn36xx: Disable 5GHz for wcn3620")
> Cc: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-current branch of ath.git, thanks.

1967c12896e0 wcn36xx: fix iris child-node lookup

-- 
https://patchwork.kernel.org/patch/10054441/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
