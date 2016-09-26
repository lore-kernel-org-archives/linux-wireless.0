Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56698 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933889AbcIZPV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 11:21:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] mwifiex: cfg80211 set_default_mgmt_key handler
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1474377383-12600-1-git-send-email-akarwar@marvell.com>
References: <1474377383-12600-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160926152127.22E4961443@smtp.codeaurora.org> (sfid-20160926_172140_776564_6FA4C79B)
Date: Mon, 26 Sep 2016 15:21:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Ganapathi Bhat <gbhat@marvell.com>
> 
> Previously device used to start using IGTK key as Tx key as soon as it
> gets downloaded in add_key(). This patch implements set_default_mgmt_key
> handler. We will update Tx key ID in set_default_mgmt_key().
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

89951db2be53 mwifiex: cfg80211 set_default_mgmt_key handler

-- 
https://patchwork.kernel.org/patch/9341673/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
