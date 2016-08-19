Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7825 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754011AbcHSKGp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 06:06:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: fix misleading indent
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160721163107.686-1-me@bobcopeland.com>
To: Bob Copeland <me@bobcopeland.com>
CC: <linux-wireless@vger.kernel.org>, Bob Copeland <me@bobcopeland.com>
Message-ID: <39885bfbe6ce468ba9fb09004aba254f@euamsexm01a.eu.qualcomm.com> (sfid-20160819_120651_825140_DEA8EF84)
Date: Fri, 19 Aug 2016 12:06:38 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> wrote:
> Fixes smatch warning:
> 
> ath9k_vif_iter_set_beacon() warn if statement not indented
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

4c51e7db87b7 ath9k: fix misleading indent

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9241937/
