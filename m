Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeC2ItC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:49:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath9k: fix DFS detector synchronization
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <071245fb726f2842c9a30432b14633e5d665b1d4.1518605287.git.tredaelli@redhat.com>
References: <071245fb726f2842c9a30432b14633e5d665b1d4.1518605287.git.tredaelli@redhat.com>
To: Timothy Redaelli <tredaelli@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>,
        Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-Id: <20180329084901.B5FDD60C65@smtp.codeaurora.org> (sfid-20180329_104906_048408_3161F0A4)
Date: Thu, 29 Mar 2018 08:49:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Timothy Redaelli <tredaelli@redhat.com> wrote:

> some userspace programs (e.g. hostapd) need to set the regulatory domain
> before selecting the operating channel. Synchronize DFS detector regardless of
> the value of ah->curchan, to avoid situations where wireless scan can't be done
> on some 5GHz sub-bands, because dfs_region is constantly UNSET.
> 
> Acked-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Timothy Redaelli <tredaelli@redhat.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4415d58c47e5 ath9k: fix DFS detector synchronization

-- 
https://patchwork.kernel.org/patch/10218409/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
