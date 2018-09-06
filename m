Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53066 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbeIFOPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:15:51 -0400
Subject: Re: [PATCH 38/42] mt76: initial separation of mmio part
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
 <1536225538-16454-39-git-send-email-sgruszka@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <df9189e2-d5b7-8744-9c55-dbff12808983@nbd.name> (sfid-20180906_114116_891961_3192ADDD)
Date: Thu, 6 Sep 2018 11:41:11 +0200
MIME-Version: 1.0
In-Reply-To: <1536225538-16454-39-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-06 11:18, Stanislaw Gruszka wrote:
> Create mt76_mmio module to contain generic mt76 PCEe/SOC code.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>I would strongly prefer to not do this. In my opinion, the mmio specific
code is not big enough to justify the extra overhead of having another
kernel module.

- Felix
