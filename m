Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57932 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbeHYMkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 08:40:25 -0400
Subject: Re: [PATCH 04/17] mt76: create new mt76xx-lib module for common
 mt76x{0,2} code
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
 <1535109321-17126-5-git-send-email-sgruszka@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <13595ea4-e052-5448-7e24-9b6c0d59cb81@nbd.name> (sfid-20180825_110209_106200_2200288F)
Date: Sat, 25 Aug 2018 11:02:04 +0200
MIME-Version: 1.0
In-Reply-To: <1535109321-17126-5-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-24 13:15, Stanislaw Gruszka wrote:
> Move rxfilter and mutex to common structure. Create mt76xx-lib.ko
> for mt76x0 and mt76x2 common functions and create new unified
> mt76xx_configure_filter() function there.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
My previous comment about mt76x2_regs.h applies here as well.

- Felix
