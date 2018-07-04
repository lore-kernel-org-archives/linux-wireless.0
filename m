Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40634 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbeGDPQx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 11:16:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/4] mt76: introduce mt76_{incr,decr} utility routines
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <2a49ca8370e2b582941b073f00438066f7ffa212.1530260731.git.lorenzo.bianconi@redhat.com>
References: <2a49ca8370e2b582941b073f00438066f7ffa212.1530260731.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180704151653.721256037C@smtp.codeaurora.org> (sfid-20180704_171713_206941_2C074BA4)
Date: Wed,  4 Jul 2018 15:16:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Add mt76_{incr,decr} utility routines to increment/decrement a value
> with wrap-around (they will be used by mt76x2 DFS sw detector)
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

4 patches applied to wireless-drivers-next.git, thanks.

ee8aa945e4ae mt76: introduce mt76_{incr,decr} utility routines
1fc9bc9ab501 mt76x2: dfs: add sw event ring buffer
b7384e4e0d56 mt76x2: dfs: add sw pattern detector
4a07ed51cae1 mt76x2: debugfs: add sw pulse statistics to dfs debugfs

-- 
https://patchwork.kernel.org/patch/10496437/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
