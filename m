Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19421 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753392AbdEDM7a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 08:59:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RESEND] ath10k: fix out of bounds access to local buffer
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170424071157.6979-1-dev@michaelmera.com>
References: <20170424071157.6979-1-dev@michaelmera.com>
To: Michael Mera <dev@michaelmera.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Michael Mera" <dev@michaelmera.com>
Message-ID: <afaf2e43f4d341e98650d6deb4b7769c@eusanexr01a.eu.qualcomm.com> (sfid-20170504_150021_103459_590B9DC3)
Date: Thu, 4 May 2017 05:59:26 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Mera <dev@michaelmera.com> wrote:
> During write to debugfs file simulate_fw_crash, fixed-size local buffer
> 'buf' is accessed and modified at index 'count-1', where 'count' is the
> size of the write (so potentially out of bounds).
> This patch fixes this problem.
> 
> Signed-off-by: Michael Mera <dev@michaelmera.com>

Patch applied to ath-next branch of ath.git, thanks.

a16703aaeaed ath10k: fix out of bounds access to local buffer

-- 
https://patchwork.kernel.org/patch/9695703/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
