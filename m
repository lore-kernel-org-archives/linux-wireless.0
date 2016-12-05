Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbcLELLJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 06:11:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: adm80211: add checks for dma mapping errors
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1480715566-17027-1-git-send-email-khoroshilov@ispras.ru>
References: <1480715566-17027-1-git-send-email-khoroshilov@ispras.ru>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Message-Id: <20161205111109.14716614F9@smtp.codeaurora.org> (sfid-20161205_121113_295362_43590C11)
Date: Mon,  5 Dec 2016 11:11:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexey Khoroshilov <khoroshilov@ispras.ru> wrote:
> The driver does not check if mapping dma memory succeed.
> The patch adds the checks and failure handling.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Patch applied to wireless-drivers-next.git, thanks.

d15697de60db adm80211: add checks for dma mapping errors

-- 
https://patchwork.kernel.org/patch/9459295/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
