Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52812 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbeIFOIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:08:32 -0400
Subject: Re: [PATCH 39/42] mt76: move some irq code to common mmio module
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
 <1536225538-16454-40-git-send-email-sgruszka@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <91c0c1d5-12a9-7155-c4bf-191a511080ee@nbd.name> (sfid-20180906_113403_458904_927A1C7C)
Date: Thu, 6 Sep 2018 11:33:55 +0200
MIME-Version: 1.0
In-Reply-To: <1536225538-16454-40-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-06 11:18, Stanislaw Gruszka wrote:
> Move some irq handling code to generic mmio module.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Please drop this patch. This won't work on MT7603 and later.

- Felix
