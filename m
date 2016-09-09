Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56142 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753017AbcIIMLT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:11:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix reporting channel survey data
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1472794193-20774-1-git-send-email-arnagara@qti.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        <arnagara@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <8d2a1b7efdc64924ac340344d036227a@euamsexm01a.eu.qualcomm.com> (sfid-20160909_141122_276241_AC45368F)
Date: Fri, 9 Sep 2016 14:11:12 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> wrote:
> When user requests for survey dump data, driver is providing wrong survey
> information. This information we sent is the survey data that we have
> collected during previous user request.
> 
> This issue occurs because we request survey dump for wrong channel. With
> this change, we correctly display the correct and current survey
> information to userspace.
> 
> Fixes: fa7937e3d5c2 ("ath10k: update bss channel survey information")
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

77eb3d693182 ath10k: fix reporting channel survey data

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9310467/
