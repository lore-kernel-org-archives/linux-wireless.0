Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753188AbdCTRJD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:09:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: send fewer channels to scan while connected
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1489661171-29796-1-git-send-email-akarwar@marvell.com>
References: <1489661171-29796-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20170320170902.19A4260795@smtp.codeaurora.org> (sfid-20170320_180910_436027_E7C0F32B)
Date: Mon, 20 Mar 2017 17:09:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> Application triggers periodic background scans when device is connected.
> We will scan less number of channels per scan command so that data
> traffic won't get affected.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

0a5cc49750b8 mwifiex: send fewer channels to scan while connected

-- 
https://patchwork.kernel.org/patch/9627821/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
