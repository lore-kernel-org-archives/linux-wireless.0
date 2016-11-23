Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47888 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934354AbcKWTmS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 14:42:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix monitor vdev for receiving other bss frames
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1479510658-8326-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1479510658-8326-1-git-send-email-rmanohar@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rajkumar Manoharan" <rmanohar@qca.qualcomm.com>,
        <rmanohar@codeaurora.org>
Message-ID: <8167e14b023b48af8cf8f277c36415d3@euamsexm01a.eu.qualcomm.com> (sfid-20161123_204221_108672_4D82E0F8)
Date: Wed, 23 Nov 2016 20:42:10 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com> wrote:
> In order to receive other BSS entries in mesh mode, Monitor vdev
> is created whenever filter flag is set with OTHER_BSS. Recently
> it is root caused that setting promisc filter for Mesh interface
> is causing performance and stability issues. To fix this issue,
> firmware will configure appropriate rxfilters by default for mesh
> vdev during vdev creation. This change fixes monitor vdev creation
> based on firmware IE
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

705d7aa06220 ath10k: fix monitor vdev for receiving other bss frames

-- 
https://patchwork.kernel.org/patch/9437519/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
