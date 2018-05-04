Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57452 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbeEDMgs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 May 2018 08:36:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: remove unnecessary break in mt76x2_mac_process_tx_rate()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180501083354.1252-1-lorenzo.bianconi@redhat.com>
References: <20180501083354.1252-1-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180504123648.279BC60310@smtp.codeaurora.org> (sfid-20180504_143652_664664_94A987A9)
Date: Fri,  4 May 2018 12:36:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Remove unnecessary break statement in the default case of bw switch
> block in mt76x2_mac_process_tx_rate routine
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

8efb868566db mt76x2: remove unnecessary break in mt76x2_mac_process_tx_rate()

-- 
https://patchwork.kernel.org/patch/10373263/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
