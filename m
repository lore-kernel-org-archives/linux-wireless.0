Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56688 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934005AbeAXPRU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:17:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] mt76x2: dfs: avoid tasklet scheduling during
 mt76x2_dfs_init_params()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <cc2633a981be777e631da2bd3d32781690db910f.1515503003.git.lorenzo.bianconi@redhat.com>
References: <cc2633a981be777e631da2bd3d32781690db910f.1515503003.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180124151720.232B7604D4@smtp.codeaurora.org> (sfid-20180124_161725_577273_86182BBA)
Date: Wed, 24 Jan 2018 15:17:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Substitute tasklet_kill with tasklet_disable/tasklet_enable in order to
> guarantee dfs tasklet can not be executed during dfs parameter
> initialization
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

3 patches applied to wireless-drivers-next.git, thanks.

8c9f6491a313 mt76x2: dfs: avoid tasklet scheduling during mt76x2_dfs_init_params()
2070f3cc2c2c mt76x2: dfs: add set_domain handler
634e99f0d4da mt76x2: dfs: take into account dfs region in mt76x2_dfs_init_params()

-- 
https://patchwork.kernel.org/patch/10152031/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
