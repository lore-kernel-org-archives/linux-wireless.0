Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdJMKAL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 06:00:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,1/8] qtnfmac: do not cache AP settings in driver structures
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171005013813.13332-2-igor.mitsyanko.os@quantenna.com>
References: <20171005013813.13332-2-igor.mitsyanko.os@quantenna.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Message-Id: <20171013100011.0832F60288@smtp.codeaurora.org> (sfid-20171013_120015_916316_E9A58990)
Date: Fri, 13 Oct 2017 10:00:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> Cached AP setings are passed to WiFi card right after they are
> initialized and are never used for anything else. There is no
> point in keeping them in driver state.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

8 patches applied to wireless-drivers-next.git, thanks.

9b692df1e66f qtnfmac: do not cache AP settings in driver structures
8b5f4aa7340a qtnfmac: pass all AP settings to wireless card for processing
f99201cb084d qtnfmac: pass channel definition to WiFi card on START_AP command
524522c445e1 qtnfmac: get rid of QTNF_STATE_AP_CONFIG
d7b80052fa91 qtnfmac: get rid of QTNF_STATE_AP_START flag
9766d1dd52ec qtnfmac: do not cache BSS state in per-VIF structure
d23d13613162 qtnfmac: make encryption info a part of CONNECT command.
ef81e8e9dbbb qtnfmac: do not cache current channel info in driver's state

-- 
https://patchwork.kernel.org/patch/9986277/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
