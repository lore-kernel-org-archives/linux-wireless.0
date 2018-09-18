Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbeIRRQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 13:16:14 -0400
Date: Tue, 18 Sep 2018 13:43:57 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] mt76x0: run vco calibration for each channel
 configuration
Message-ID: <20180918114356.GB15285@redhat.com> (sfid-20180918_134409_178616_ADB90F98)
References: <20180907211312.17918-1-lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180907211312.17918-1-lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 07, 2018 at 11:13:12PM +0200, Lorenzo Bianconi wrote:
> According to vendor sdk, vco calibration has to be executed
> for each channel configuration whereas mcu calibration has to be
> performed during channel scanning. This patch fixes the mt76x0
> monitor mode issue since in that configuration vco calibration
> was never executed
> 
> Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
> Tested-by: Sid Hayn <sidhayn@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
