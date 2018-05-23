Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754054AbeEWH4k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 03:56:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: apply coverage class on slot time too
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180515100814.491-1-lorenzo.bianconi@redhat.com>
References: <20180515100814.491-1-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org, luca.bisti@gmail.com,
        gaetano.catalli@gmail.com
Message-Id: <20180523075639.900F360314@smtp.codeaurora.org> (sfid-20180523_095736_932795_D077D723)
Date: Wed, 23 May 2018 07:56:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> According to 802.11-2007 17.3.8.6 (slot time), the slot time should
> be increased by 3 us * coverage class. Taking into account coverage
> class in slot time configuration allows to increase by an order of
> magnitude the throughput on a 4Km link in a noisy environment
> 
> Tested-by: Luca Bisti <luca.bisti@gmail.com>
> Tested-by: Gaetano Catalli <gaetano.catalli@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

0d45d3fe42ef mt76x2: apply coverage class on slot time too

-- 
https://patchwork.kernel.org/patch/10400771/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
