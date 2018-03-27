Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbeC0JLq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 05:11:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: fix possible NULL pointer dereferencing in mt76x2_tx()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180317112927.18299-1-lorenzo.bianconi@redhat.com>
References: <20180317112927.18299-1-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180327091145.A070D60F5F@smtp.codeaurora.org> (sfid-20180327_111150_109550_DEB8B8C4)
Date: Tue, 27 Mar 2018 09:11:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix a theoretical NULL pointer dereferencing in mt76x2_tx routine that
> can occurs for injected frames in a monitor vif since vif pointer could
> be NULL for that interfaces
> 
> Fixes: 23405236460b ("mt76: fix transmission of encrypted mgmt frames")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

6958b027435a mt76x2: fix possible NULL pointer dereferencing in mt76x2_tx()

-- 
https://patchwork.kernel.org/patch/10290771/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
