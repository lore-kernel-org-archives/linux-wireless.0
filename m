Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbeG3QIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 12:08:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mt76x2: fix CCK protection control frame rate
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <cd663daf364d7967b3a8d9fd7f213139c959d0c1.1531385150.git.lorenzo.bianconi@redhat.com>
References: <cd663daf364d7967b3a8d9fd7f213139c959d0c1.1531385150.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180730143303.AB52161D77@smtp.codeaurora.org> (sfid-20180730_163306_331548_A677FF19)
Date: Mon, 30 Jul 2018 14:33:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Use 11M as tx rate for CCK protection control frames
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

d0db2f7a02e4 mt76x2: fix CCK protection control frame rate

-- 
https://patchwork.kernel.org/patch/10521349/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
