Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030584AbdDZJFd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 05:05:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] brcmfmac: Make skb header writable before use
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170425091506.18224-1-james.hughes@raspberrypi.org>
References: <20170425091506.18224-1-james.hughes@raspberrypi.org>
To: James Hughes <james.hughes@raspberrypi.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        James Hughes <james.hughes@raspberrypi.org>
Message-Id: <20170426090532.8686D61493@smtp.codeaurora.org> (sfid-20170426_113351_728609_48702FB9)
Date: Wed, 26 Apr 2017 09:05:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Hughes <james.hughes@raspberrypi.org> wrote:
> The driver was making changes to the skb_header without
> ensuring it was writable (i.e. uncloned).
> This patch also removes some boiler plate header size
> checking/adjustment code as that is also handled by the
> skb_cow_header function used to make header writable.
> 
> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

9cc4b7cb86cb brcmfmac: Make skb header writable before use

-- 
https://patchwork.kernel.org/patch/9697763/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
